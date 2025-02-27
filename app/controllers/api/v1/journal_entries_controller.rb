class Api::V1::JournalEntriesController < ApplicationController
  def index
    month = params[:month] || Date.today.strftime("%Y-%m")
    start_of_month = Date.strptime(month, "%Y-%m").beginning_of_month
    end_of_month = start_of_month.end_of_month

    journal_entry = Order.where(ordered_at: start_of_month..end_of_month)
                     .includes(:payments)
                     .group_by { |o| o.ordered_at.strftime("%Y-%m") }
                     .map do |month, orders|
      total_sales = orders.sum(&:total_sales)
      total_shipping = orders.sum(&:shipping)
      total_taxes = orders.sum(&:total_taxes)
      total_payments = orders.flat_map(&:payments).sum(&:payment_amount)

      {
        month: month,
        entries: [
          { account: "Accounts Receivable", debit: total_sales + total_shipping + total_taxes, credit: 0 },
          { account: "Revenue", debit: 0, credit: total_sales },
          { account: "Shipping Revenue", debit: 0, credit: total_shipping },
          { account: "Sales Tax Payable", debit: 0, credit: total_taxes },
          { account: "Cash", debit: total_payments, credit: 0 },
          { account: "Accounts Receivable", debit: 0, credit: total_payments }
        ],
        total_debits: total_sales + total_shipping + total_taxes + total_payments,
        total_credits: total_sales + total_shipping + total_taxes + total_payments
      }
    end

    render json: journal_entry
  end
end
