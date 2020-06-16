class Video < ApplicationRecord
  belongs_to :movie
  validates_presence_of :size, :format, :url
end