class List < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :movies
  validates_presence_of :name, :description
  validates :public, inclusion: { in: [true, false] }
end
