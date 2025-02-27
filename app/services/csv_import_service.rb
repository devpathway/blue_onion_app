require "csv"

class CsvImportService
  def self.import_orders(file_path)
    CSV.foreach(file_path, headers: true) do |row|
      order = Order.find_or_create_by(order_id: row["order_id"]) do |o|
        o.ordered_at = DateTime.parse(row["ordered_at"])
        o.item_type = row["item_type"]
        o.price_per_item = row["price_per_item"].to_d
        o.quantity = row["quantity"].to_i
        o.shipping = row["shipping"].to_d
        o.tax_rate = row["tax_rate"].to_d
      end

      (1..2).each do |i|
        payment_id = row["payment_#{i}_id"]
        payment_amount = row["payment_#{i}_amount"].to_d
        next if payment_id.blank? || payment_amount.zero?

        Payment.create!(
          payment_id: payment_id,
          order: order,
          payment_date: order.ordered_at,
          payment_amount: payment_amount
        )
      end
    end
  end
end
