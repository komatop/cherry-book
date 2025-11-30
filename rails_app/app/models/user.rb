class User < ApplicationRecord
  has_many :orders

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :points, numericality: { greater_than_or_equal_to: 0 }
end
