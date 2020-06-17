class List < ApplicationRecord
  default_scope { where(public: true) }

  belongs_to :user
  has_and_belongs_to_many :movies
end