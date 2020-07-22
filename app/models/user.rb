class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable

  has_many :lists, dependent: :destroy
  accepts_nested_attributes_for :lists
  validates_presence_of :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP } 
  validates_presence_of :full_name, presence: true
  validates_presence_of :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
end
