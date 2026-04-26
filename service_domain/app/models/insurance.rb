class Insurance < ApplicationRecord
  validates :policy_number, presence: true, uniqueness: true
  validates :provider, presence: true
  validates :premium_cents, numericality: { greater_than_or_equal_to: 0 }
end
