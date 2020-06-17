class Movie < ApplicationRecord
  scope :filter_by_title, -> (title) { where("title like ?", "#{title}%")}
  
  has_many :videos, dependent: :destroy
  has_and_belongs_to_many :lists
  accepts_nested_attributes_for :videos

  validates_presence_of :title, :tagline, :overview, :release_date, :poster_url, :backdrop_url, :imdb_id
end