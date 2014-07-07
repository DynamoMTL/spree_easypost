class CreateEasypostEvents < ActiveRecord::Migration
  def change
    create_table :easypost_events do |t|
      # references spree order
      t.references :order 

      t.string :easypost_id
      t.string :object
      t.string :mode
      t.string :description
      t.text   :previous_attributes
      # contains tracking result
      t.text   :result      
      t.timestamps
    end
  end
end
