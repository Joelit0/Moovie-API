class Movie < ApplicationRecord
  scope :filter_by_title, -> (title) { where("title like ?", "#{title}%")}
  has_many :videos, dependent: :destroy
  accepts_nested_attributes_for :videos
end

