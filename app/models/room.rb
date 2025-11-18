class Room < ApplicationRecord
  validates :code, presence: true, uniqueness: true, length: { maximum: 6 }
  validates :name, presence: true
end