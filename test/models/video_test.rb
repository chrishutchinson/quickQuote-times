require 'test_helper'
# to run the test, from terminal in root of application:
# and make sure local MySql db is turned on for testing (from os x system preferences)
# rake test test/models/video_test.rb

# # starting local mysql
# `sudo /usr/local/mysql/support-files/mysql.server start`
# # shutting down local mysql
# `sudo /usr/local/mysql/support-files/mysql.server stop`

class VideoTest <  ActiveSupport::TestCase

  test "should not save video without title" do
    video = Video.new
    assert_not video.save, "Saved the video without a title"
  end

  test "should not save video without video file, media" do
    video = Video.new(title: "Test Video")
    assert_not video.save, "Saved the video without a video file"
  end

  test "Should save a video, with a valid video file attachment" do
    # Sample video attachment
    def sample_video_file(filename = "test_video.mp4")
      File.new("test/selenium/#{filename}")
    end
    @video = Video.new(title: "Test Video")
    @video.media = sample_video_file("test_video.mp4")
    assert @video.save, "Saved the video with a video file"
  end

  test "Should convert srt string into hyperTranscript data structure" do
    # Sample video attachment
    def sample_video_file(filename = "test_video.mp4")
      File.new("test/selenium/#{filename}")
    end
    # open sample srt file, and returns it's content as a String
    def sample_srt_file(filename = "Kyle_captions.srt")
      data = ""
      file = File.open("test/srt_test_file/#{filename}", "r")
      file.each_line do |line|
        data += line
      end
      return data
    end
    # regex made using http://www.regexr.com/
    # HyperTranscript data structure example
    # [[{"tc_in"=>0.049, "tc_out"=>1.1656666666666666, "word"=>"God"}, {"tc_in"=>0.4212222222222222, "tc_out"=>3.399, "word"=>"maintain"}, {"tc_in"=>0.7934444444444445, "tc_out"=>1.1656666666666666, "word"=>"I"}, {"tc_in"=>1.1656666666666666, "tc_out"=>2.2823333333333333, "word"=>"and"}, {"tc_in"=>1.5378888888888889, "tc_out"=>3.026777777777778, "word"=>"Kyle"}, {"tc_in"=>1.910111111111111, "tc_out"=>3.399, "word"=>"show"}, {"tc_in"=>2.2823333333333333, "tc_out"=>3.7712222222222223, "word"=>"from"}, {"tc_in"=>2.6545555555555556, "tc_out"=>6.004555555555555, "word"=>"Lewistown"}, {"tc_in"=>3.026777777777778, "tc_out"=>5.632333333333333, "word"=>"Montana"}], [{"tc_in"=>3.399, "tc_out"=>6.5, "word"=>"atomic"}, {"tc_in"=>3.9158333333333335, "tc_out"=>7.533666666666667, "word"=>"Western"}, {"tc_in"=>4.432666666666667, "tc_out"=>7.533666666666667, "word"=>"called"}, {"tc_in"=>4.9495000000000005, "tc_out"=>8.567333333333334, "word"=>"Bochner"}, {"tc_in"=>5.466333333333333, "tc_out"=>8.0505, "word"=>"since"}, {"tc_in"=>5.983166666666667, "tc_out"=>8.050500000000001, "word"=>"2008"}],...]
    hyperTranscript_regex = /(\[?(\[(\{(("\w+'?\/?-?\w+"=>(\d+\.\d+|"\w+'?\/?-?\w*"))[,\ ]*)+\}(,? ?))+\]?,?\ ?)\]?)*/
    video = Video.new(title: "Test Video")
    video.media = sample_video_file("test_video.mp4")
    video.save
    assert_match hyperTranscript_regex, video.convert_srt_to_word_accurate_hypertranscript(sample_srt_file("Kyle_captions.srt")).to_s, "Matches HyperTranscript Regex"
    # assert_match /\[#{word}/ , video.convert_srt_to_word_accurate_hypertranscript(sample_srt_file("Kyle_captions.srt"))
  end

  test "Should save HyperTranscript to database" do
    # Sample video attachment
    def sample_video_file(filename = "test_video.mp4")
      File.new("test/selenium/#{filename}")
    end
    #sample srt file content String
    def sample_srt_file(filename = "Kyle_captions.srt")
      File.new("test/srt_test_file/#{filename}")
    end
    video = Video.new(title: "Test Video")
    video.media = sample_video_file("test_video.mp4")
    video.save
    hyperTranscript = video.convert_srt_to_word_accurate_hypertranscript(sample_srt_file("Kyle_captions.srt"))
    video.save_to_db(hyperTranscript)
    assert video.transcriptions.exists?
  end


end


