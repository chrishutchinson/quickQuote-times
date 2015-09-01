##
# Lines are used to group words of the transcription.
# At the moment the line breaks between words are defined by the line breaks of the srt file returned by the speech to
# text API.
class Line < ActiveRecord::Base
  belongs_to :transcription
  has_many :words , dependent: :destroy
end
