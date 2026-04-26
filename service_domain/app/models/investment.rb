class Investment < ApplicationRecord
  validates :name, presence: true
  validates :kind, presence: true
  validates :amount_cents, numericality: { greater_than_or_equal_to: 0 }
end
