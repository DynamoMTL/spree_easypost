class CreateEasypostShipments < ActiveRecord::Migration
  def change
    create_table :easypost_shipments do |t|
      # belongs to spree order and shipment
      t.references :order, :shipment

      t.string :easypost_id

      t.string :object
      t.string :mode
      t.string :tracking_code
      t.string :reference
      t.string :refund_status
      t.float :insurance
      t.string :batch_status
      t.string :batch_message

      t.timestamps
    end
  end
end
