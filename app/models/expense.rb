class Expense < ApplicationRecord
  belongs_to :user

  enum :recurring, {monthly: "monthly"}, validate: {allow_nil: true}
  scope :recurring, -> { where.not(recurring: nil) }

  def amount=(value)
    amount_in_cents = BigDecimal(value.to_s) * 100
    super(amount_in_cents)
  end

  def amount_from_cents
    amount / 100.0
  end
end
