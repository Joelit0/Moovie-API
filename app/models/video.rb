class Video < ApplicationRecord
  belongs_to :movie
  validates_presence_of :size
  validates_presence_of :format
  validates_presence_of :url
end
