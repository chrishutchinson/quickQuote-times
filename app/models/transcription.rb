##
# The transcription class keeps the text of the transcription organised into lines and words.
class Transcription < ActiveRecord::Base
  belongs_to :video
  has_many :lines , dependent: :destroy
  has_many :words, :through =>  :lines
  # has_many :words, :through => :lines

  ##
  # A test method to that adds punctuation to a transcription, by adding a `.` at every line break.
  # This is usefull if working with a automaticlaly generated transcription from spoken data where the transcription
  # will not have punctuaiton by default.
  # approaximate the punctuation, using the original line breaks from the srt file produced by the text to speech API.
  def return_text_with_punctuation
    sentences =[]
    self.lines.each do |l|
      # reset the sentence array for every line
      sentence=[]
      # add every word that belong to a line to the sentence array
        l.words.each do | w|
          sentence <<  w.word
        end
      # joining words into sentence as divided by lines in the database.
      sentences << sentence.join(" ")
    end
    # joining sentences, with full stop.
    sentences = sentences.join(". ")
    #if using with [ruby summarization algorith](https://github.com/darkshadow/summarization) uncoment next two lines
    # they remove sentences with one word, and with two words,  as a workaround of  the summarization  algo bug
    # (it crashes if sentence is had one or two words only)

    # sentences = sentences.gsub(/\. [a-zA-Z_0-9]*\./," ")
    # sentences = sentences.gsub(/\. [A-Za-z]* [A-Za-z]*\./," ")
    return sentences
  end
end
