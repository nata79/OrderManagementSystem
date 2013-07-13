class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :status
      t.date :order_date
      t.float :vat

      t.timestamps
    end
  end
end
