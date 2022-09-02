class DailyExpense < ApplicationRecord
  belongs_to :user

  def amount=(value)
    amount_in_cents = BigDecimal(value.to_s) * 100
    super(amount_in_cents)
  end

  def amount_from_cents
    amount / 100.0
  end
end
