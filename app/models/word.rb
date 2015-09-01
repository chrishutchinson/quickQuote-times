##
# Words are the lowest level of granularity of the transcription, and they are grouped into lines.
class Word < ActiveRecord::Base
  belongs_to :line
  has_one :transcription, :through =>  :line
  # has_one :video, through: :line
end
