class Order < ApplicationRecord
  has_many :payments, dependent: :destroy

  def total_sales
    price_per_item * quantity
  end

  def total_taxes
    total_sales * tax_rate
  end

  def total_payments
    payments.sum(:payment_amount)
  end
end
