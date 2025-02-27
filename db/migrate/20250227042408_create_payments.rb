class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.string :payment_id
      t.references :order, null: false, foreign_key: true
      t.datetime :payment_date
      t.decimal :payment_amount

      t.timestamps
    end
  end
end
