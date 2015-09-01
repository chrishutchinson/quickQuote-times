##
# convert srt file to word_accurate hypertranscript
# convertend into ruby from [hyperaudio converter javascript opensoure project by Boas](https://github.com/maboa/hyperaudioconverter)
# within rails you can call it like so
# ```ruby
#  require "#{Rails.root}/lib/hypertranscriptConverter.rb"
#  htConverter= HypertranscriptConverter.new
#  ht_data_structure= htConverter.parse_srt_String(srt_string)
# ```
# @param [srt file String]
# @return [ruby hash hypertranscript data structure]
class HypertranscriptConverter
  def parse_srt_String(srt_string)
    # creates a file out of the srt file content String using [srt library](https://github.com/cpetersen/srt), example :
    # ```
    # => #<SRT::File:0x007fcc8ab349b8 @lines=[#<SRT::Line:0x007fcc8ab34990 @sequence=1, @start_time=0.68, @end_time=1.4, @text=["i everybody"]>, #<SRT::Line:0x007fcc8ab3e3a0 @sequence=2, @start_time=2.53, @end_time=8.51, @text=["this week i plan to join the students teachers", "businesses and nonprofit organisations taking", "big"]> ...
    #```
    require 'srt'
    file = SRT::File.parse(srt_string)

    srt_hash=[]
    line_number = 1

    # Iterates over lines of srt file.
    file.lines.each do |line|
      # array of words in the line
      # in srt file object text is stored as array of string
      #example
      # ```
      #<SRT::Line:0x007fcc8ab3db80 @sequence=3, @start_time=8.51, @end_time=11.6, @text=["new steps to support computer science in", "american schools"]>, ..
      #````
      # two strings make up the text of a line  in the srt file, we join them into one string, and then split at space to make an array of words.
      words_in_a_line = line.text.join(" ").split(" ")
      number_of_words_in_line = words_in_a_line.size
      # time duration of line time start - time end
      line_duration = line.end_time - line.start_time
      # average_word_duration is the duration of the line divided by the number of words in the line
      average_word_duration  = line_duration / number_of_words_in_line
      # to calculate the number of letters in a sentence
      number_of_letters_in_a_sentence =0
      # we loop through the array of words, and add up the size of each word
      words_in_a_line.each do |word|
        number_of_letters_in_a_sentence += word.size
      end
      word_counter =0
      one_line_array_or_words =[]
      words_in_a_line.each do |word|
        # word duration is equal to number of letters
        word_duration = word.size * average_word_duration
        word_start_time = line.start_time + word_counter * average_word_duration
        word_end_time = word_start_time+word_duration
        corresponding_word = line.text.join(" ").split(" ")[word_counter]
        # saving into hypertranscript ruby hash data structure
        word_hash ={}
        word_hash['tc_in'] = word_start_time.to_f
        word_hash['tc_out'] = word_end_time.to_f
        word_hash['word']= corresponding_word.to_s
        one_line_array_or_words << word_hash
        word_counter +=1
      end
      # adding onto hypertranscript ruby hash data structure
      srt_hash << one_line_array_or_words
      # reset the  `one_line_array_or_words`
      one_line_array_or_words =[]
      line_number +=1
    end
    #returning hypertranscript ruby hash data structure
    return srt_hash
    # example output
    # array of array where each word is an hash with tc in , tc out and text,
    # and words in a line are then inner array, and whole of the lines are contained in
    # the outer array
    # [[{"tc_in"=>0.049, "tc_out"=>1.1656666666666666, "word"=>"God"}, {"tc_in"=>0.4212222222222222, "tc_out"=>3.399, "word"=>"maintain"}, {"tc_in"=>0.7934444444444445, "tc_out"=>1.1656666666666666, "word"=>"I"}, {"tc_in"=>1.1656666666666666, "tc_out"=>2.2823333333333333, "word"=>"and"}, {"tc_in"=>1.5378888888888889, "tc_out"=>3.026777777777778, "word"=>"Kyle"}, {"tc_in"=>1.910111111111111, "tc_out"=>3.399, "word"=>"show"}, {"tc_in"=>2.2823333333333333, "tc_out"=>3.7712222222222223, "word"=>"from"}, {"tc_in"=>2.6545555555555556, "tc_out"=>6.004555555555555, "word"=>"Lewistown"}, {"tc_in"=>3.026777777777778, "tc_out"=>5.632333333333333, "word"=>"Montana"}],...
  end

end