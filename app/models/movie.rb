class Movie < ApplicationRecord
  scope :filter_by_title, -> (title) { where("title like ?", "#{title}%")}
end

