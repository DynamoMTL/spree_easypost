class RenameSpreePostageLabelsToEasypostPostageLabels < ActiveRecord::Migration
  def change
    rename_table :spree_postage_labels, :easypost_postage_labels

    add_column :easypost_postage_labels. :easypost_shipment_id, :integer
  end
end
