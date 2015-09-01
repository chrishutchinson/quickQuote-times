##
# The video class has an attachment file using the paperclip gem
# it also invokes methods of the speech to text API to send the video and retrieve transcription.
class Video < ActiveRecord::Base
  belongs_to :user
  has_many :transcriptions, dependent: :destroy
  # has_many :words, through: :lines
  has_many :quotes,  dependent: :destroy
  validates :title, presence: true
  # Paperclip http://www.thoughtbot.com/projects/paperclip
  has_attached_file :media,
                    :storage => :s3,
                    :s3_credentials => Proc.new{|a| a.instance.s3_credentials },
                    :path => ":class/:attachment/:id/:filename" #.:extension
  def s3_credentials
    {:bucket =>  ENV['AMAZON_S3_BUCKET'], :access_key_id => ENV['AMAZON_S3_ACCESS_KEY_ID'], :secret_access_key =>  ENV['AMAZON_S3_SECRET_ACCESS_KEY']}
  end

  # `/\Avideo/` regex identifies any type of video, will need to do same thing for audio.
  validates_attachment_content_type :media, :content_type =>['video/mp4',/\Avideo/],
                                    :message => "Sorry, right now we only support MP4 video, up to 256MB"
  # validates_attachment_content_type :audio,  :content_type => ['audio/x-wav','audio/wav','audio/mpeg', 'audio/x-mpeg', 'audio/mp3', 'audio/x-mp3', 'audio/mpeg3', 'audio/x-mpeg3', 'audio/mpg', 'audio/x-mpg', 'audio/x-mpegaudio' ],  :message => 'Please select a .wav file'
  # validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  # has_destroyable_file :media

  # Restriction for file upload onto spoken data speech to text API
  # could add intermediate step of transcoding down to 256mb for larger files using ffmpeg
  # and then uploading onto Spoken Data.
  validates_attachment_size :media, less_than: 256.megabytes
  validates_attachment_presence :media

  require "#{Rails.root}/lib/spokenDataAPI.rb"

  def send_to_text_to_speech
    spoken_data_api_object = SpokenDataAPI.new(ENV['SPOKEN_DATA_USER_ID'],ENV['SPOKEN_DATA_API_TOKEN'])
    uid = spoken_data_api_object.send_by_video_url(self.link.to_s)
    self.uid = uid
    self.save
  end

  ##
  # a method to check if the video as been processed by the text to speech API
  # @param [spoken data uid]
  # No return
  # updates the `is_processed` video attribute in database
  # if saves transcription into database
  def check_is_video_processed
    spokenDataAPIObject = SpokenDataAPI.new(ENV['SPOKEN_DATA_USER_ID'],ENV['SPOKEN_DATA_API_TOKEN'])

    @response = spokenDataAPIObject.recording_processed?(self.uid)

    @video =  Video.find_by_uid(self.uid)

    if @response == false
      @video.is_processed = false
      @video.save
    else
      if @video.is_processed == false

        @video.parse_srt_and_save_into_db(self.uid)
        @video.is_processed = true
        @video.save
      end
    end

  end

  ##
  # retrieve and parse srt file from speech to text API to save into database
  # @param [spoken data uid]
  def parse_srt_and_save_into_db(video_uid)
    spokenDataAPIObject = SpokenDataAPI.new(ENV['SPOKEN_DATA_USER_ID'],ENV['SPOKEN_DATA_API_TOKEN'])
    subtitles_srt_string = spokenDataAPIObject.retrieve_subtitles_srt(video_uid)
    hyper_transcript_hash = convert_srt_to_word_accurate_hypertranscript(subtitles_srt_string)
    save_to_db(hyper_transcript_hash)
  end

  ##
  # saves hypertranscript data structure, ruby hash, into database.
  # @param [ruby hash, hypertranscript data structure]
  def save_to_db(hyper_transcript_hash)
    @transcription = self.transcriptions.create(:name=>"Transcription_#{Time.now}")
    line_number = 0
    hyper_transcript_hash.each do |one_line|
      @line = @transcription.lines.create
      one_line.each do |l|
        @line.words.create(:tc_in => l['tc_in'], :tc_out => l['tc_out'], :word => l['word'])
      end
    end

  end

  ##
  # as the name sudgests, a method to delete a video file fromt he speech to text api
  def delete_video_from_speech_to_text_api
      spokenDataAPIObject = SpokenDataAPI.new(ENV['SPOKEN_DATA_USER_ID'],ENV['SPOKEN_DATA_API_TOKEN'])
      spokenDataAPIObject.delete_recording(self.uid)
  end

  require "#{Rails.root}/lib/hypertranscriptConverter.rb"

  def convert_srt_to_word_accurate_hypertranscript(srt_string)
    htConverter= HypertranscriptConverter.new
    ht_data_structure= htConverter.parse_srt_String(srt_string)
    return ht_data_structure
  end

end


