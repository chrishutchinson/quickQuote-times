##
# Uses [paperclip gem](https://github.com/thoughtbot/paperclip) to store attachment file `snippet` in Amazon S3 Bucket
class Quote < ActiveRecord::Base
  belongs_to :video
  has_attached_file :snippet,
                    :storage => :s3,
                    :s3_credentials => Proc.new{|a| a.instance.s3_credentials },
                    :path => "videos/quotes/:id/:filename" #.:extension
  def s3_credentials
    {:bucket =>  ENV['AMAZON_S3_BUCKET'], :access_key_id => ENV['AMAZON_S3_ACCESS_KEY_ID'], :secret_access_key =>  ENV['AMAZON_S3_SECRET_ACCESS_KEY']}
  end
  # do_not_validate_attachment_file_type :snippet
  validates_attachment_content_type :snippet, :content_type =>['application/mp4', 'audio/mp4', 'video/mp4', /\Avideo/,  'inode/x-empty','video/vnd.objectvideo']
                                     # :message => "Sorry, right now we only support MP4 video"
  # validates_attachment_content_type :audio,  :content_type => ['audio/x-wav','audio/wav','audio/mpeg', 'audio/x-mpeg', 'audio/mp3', 'audio/x-mp3', 'audio/mpeg3', 'audio/x-mpeg3', 'audio/mpg', 'audio/x-mpg', 'audio/x-mpegaudio' ],  :message => 'Please select a .wav file'
  # has_destroyable_file :snippet
end