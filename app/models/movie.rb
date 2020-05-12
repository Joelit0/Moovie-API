class Movie < ApplicationRecord
  scope :filter_by_title, -> (title) { where("title like ?", "#{title}%")}
  has_many :videos, dependent: :destroy
  accepts_nested_attributes_for :videos
  validates_presence_of :title
  validates_presence_of :tagline
  validates_presence_of :overview
  validates_presence_of :release_date
  validates_presence_of :poster_url
  validates_presence_of :backdrop_url
  validates_presence_of :imdb_id
end

