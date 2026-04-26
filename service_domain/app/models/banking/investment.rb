# frozen_string_literal: true

module Banking
  class Investment < ApplicationRecord
    self.table_name = "banking_investments"

    validates :name, presence: true
    validates :kind, presence: true
    validates :amount_cents, numericality: { greater_than_or_equal_to: 0 }
  end
end
