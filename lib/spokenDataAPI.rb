require 'net/http'
require 'open-uri'
require 'json'
require 'nokogiri'
##
# An SDK for the spoken data API.<br>
# @author : Pietro Passarelli <br>
# date: 22/07/2015 <br>
# [Link to Spoken Data API specifications](http://spokendata.com/api) <br>
# Spoken Data returns an XML.<br>
# This SDK does not implement all of the RESTFULL methods.<br>
# it implements:
#   - retrieving srt file of recording if ready **`retrieve_subtitles_srt(recording_id)`** using spoken data uid, if ready returns srt file string, if not returns false boolean.
#   -  send video by URL **`send_by_video_url(video_url)`** which returns the spoken data video `uid`,that you should save for later retrieval.
#   - also implemented getting **list of recordings** (not in use in example)
#   - **`get_recording_by_recording_id(recording_id)`**, returns a recording object  (also used as helper method)
#   - **`delete_recording(recording_id)`**
# You can test this as a [rails runner](http://guides.rubyonrails.org/command_line.html#rails-runner),
# - uncomment the three steps example at the end of the page
# - and run from terminal, from the root of the project.
# ```bash
#   rails r app/models/spokenDataAPI.rb
# ````
# to use it in rails add it as a model `spokenDataAPI.rb`

class SpokenDataAPI


  @@BASE_URL ="http://spokendata.com/api/"
  #Setup the endpoints
  @@ENDPOINTS = {}

  #recordingList  returns all user recordings --> this contains `status` , either 'processing' or 'done'
  @@ENDPOINTS['recordingList']="/recordingList"


  ##################### initializer
  def initialize(user_id, api_token)
    @@USER_ID = user_id.to_s
    @@API_TOKEN = api_token.to_s
  end

  ##
  # to delete the recording video file on the spoken data server
  # @param [spoken data uid]
  def delete_recording(recording_id)
    request_url = get_base_api_request.to_s + "/recording/#{recording_id}/delete"
    open(request_url)
  end

  ##
  # external libraries helper methods
  # open URLs, and returns it's content, can be a file, such as srt or xml.
  # @param [url string]
  # @return [content of url]
  def open(url)
    if URI.parse(url)
    Net::HTTP.get(URI.parse(url))
    else
      raise "error"
    end
  end

  ##
  # parses url / XML (as received by the API)
  # @param [url / XML (as received by the API)]
  # @return  [ruby hash]
  def parse_xml(url)

    # IMPORTANT: there is an issue with the xml, the encoding returned by the API is written `utf8` instead of `utf-8`. and that trips up the parser. enche the substitution
    result_string = open(url).gsub("utf8","utf-8")
    # Parse the xml with nokogiri
    nokogiri_xml_document = Nokogiri::XML(result_string)
    # transform the xml into a ruby hash using built in active support methods.
    result = Hash.from_xml(nokogiri_xml_document.to_s)
    # `data` tag encapsulate the rest of the keys /tags/
    return result['data']
  end

  # API Query builder helper methods
  def get_base_url
    return @@BASE_URL
  end

  def get_api_key
    return @@API_TOKEN
  end

  def get_user_id
    return @@USER_ID
  end

  def get_base_api_request
    url = get_base_url + get_user_id+"/" + get_api_key
    return url
  end

  def get_recordings_list
    url = get_base_api_request + @@ENDPOINTS['recordingList']
    result = parse_xml(url)
    return  result['recordings']['recording']
  end


  ##
  # gets the recording based on id
  # the id is the one defined by spokendata
  # @param [spoken data uid]
  # @returns (the whole recording object)
  def get_recording_by_recording_id(recording_id)
    url = get_base_api_request + @@ENDPOINTS['recordingList']
    Rails.logger.info  "url: #{url}"
    result = parse_xml(url)
    Rails.logger.info "result: #{result}"
    recordings =  result['recordings']['recording']
    recordings.select do |k,v|
      if k['id'].to_i == recording_id.to_i
        result = k
      end
    end
    #retursn the recording
    return result
  end

  ##
  # helper method for `get_recordings_status`
  # takes in a recording object
  # @param (recording object)
  # @return (true if "done",false if "processing" )
  def get_recording_status(recording)
    recording_status = recording['status']
    if recording_status =="done"
      return true
    elsif recording_status =="processing"
      return false
    else
      "There was an error assessing the status of the recording"
    end
  end

  ##
  # from recording `id` return boolean for status of the recording.
  # true if "done" false if "processing"
  # @param [spoken data uid]
  # @return [true if "done" false if "processing"]
  def recording_processed?(recording_id)
    recording = get_recording_by_recording_id(recording_id)
    return get_recording_status(recording)
  end

  ##
  # helper method for retrieve_subtitles_srt<br>
  #spoken data srt file actually returns a String containing the content of the srt file.<br>
  #  sample output of what spoken data returns using the demo API user and key<br>
  # `http://spokendata.com/api/18/br3sp59a2it7fig94jdtbt3p9ife5qpx39fd8npp/recording/845/subtitles.srt`
  # ```
  # => "1\r\n00:00:00,680 --> 00:00:01,400\r\ni everybody\r\n\r\n2\r\n00:00:02,530 --> 00:00:08,510\r\nthis week i plan to join the students teachers\r\nbusinesses and nonprofit organisations taking\r\nbig\r\n\r\n ...."
  # ```
  # @param [spoken data uid]
  # @return [srt file String]
  def get_srt(recording_id)
    url = get_base_api_request.to_s + "/recording/#{recording_id.to_s}/subtitles.srt"
    # Rails.logger.debug "DEBUG #{open(url).class}"
    return open(url)
  end

  ##
  # retrieves subitles srt file
  # @param [spoken data uid]
  # @return (false if recording status is "processing", string containing srt file if status is "done")
  def retrieve_subtitles_srt(recording_id)
    if recording_processed?(recording_id)
      return get_srt(recording_id)
    else
      false
    end

  end

  ##
  # Method to send video for captioning
  # takes in the location url of the video, for instance if you are using amazon S3 this is the full path, if using youtube is just normal URL, also works with Vimeo.<br />
  # returns the recording id, to be able to check status and retrieve captions subsequently, best to save this in the database. <br />
  # language options are
  # from API documentation:
  #```
  #   RECORDING-URL - YouTube or any direct URL of a media file
  #   LANGUAGE - english | english-broadcastnews | english-test | russian | chinese-ma | spanish-us | czech | czech-medicine | czech-broadcastnews | slovak
  #   ANNOTATOR-ID = id of assigned annotator (leave empty if no annotator)
  # ```
  # if you are working with languages other then english you could modify params of this url to change language option.
  # @param [url of video]
  # @return [spokn data uid]
  def send_by_video_url(url)
    request_url = get_base_api_request.to_s + "/recording/add?url=#{url}&language=english"
    response = parse_xml(request_url)
    # example response from api #{"message"=>"This media URL and language have already been entered.", "recording"=>{"id"=>"5747"}}
    return response['recording']['id']
    return response
  end



end # end of class SpokenDataAPI
####################


# #################### How to use, example in 3 steps
# # 1.Creates a spoken data api instance initialising it with user_id and API key.
# # you'll find these in http://spokendata.com/api once you have loged in.
# # use enviroment variables to store user id and api key, and remember to put the file in `.gitignore`
#
# spokenDataAPIObject = SpokenDataAPI.new(ENV['SPOKEN_DATA_USER_ID'],ENV['SPOKEN_DATA_API_TOKEN'])
#
#
# # 2. send video by URL
# # sending a video by url will return you the spoken data api assigned video ID
# # Note this only works for youtube videos that do not have advertising at the beginning o the video
# uid = spokenDataAPIObject.send_by_video_url("https://youtu.be/e6GFEfJtlnc")
# puts "UID: "+uid
#
# # 3. retrieve captions
# # use recording id / uid to retrieve subtitles, when ready. (will return false if they are not ready)
# # (good idea to save uid in db for checking on processing of video captions)
# # returns srt file if ready, boolean false if not => you can `if response != false` etc..
# # as a first run when uploading you should expect false as your video is still being processed.
# # also spoken data won't let you upload the same video more then once.
# response= spokenDataAPIObject.retrieve_subtitles_srt(uid)
# puts "Response: "+response.to_s
# ####################
