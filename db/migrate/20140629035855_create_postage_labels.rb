class CreatePostageLabels < ActiveRecord::Migration
  def change
    create_table :spree_postage_labels do |t|
      # belongs to spree shipment
      t.references :shipment

      t.string    :easypost_id
      t.integer   :date_advance      
      t.string    :integrated_form      
      t.datetime  :label_date
      t.integer   :label_resolution
      t.string    :label_size
      t.string    :label_type
      t.string    :label_file_type
      t.string    :label_url
      t.string    :label_pdf_url
      t.string    :label_epl2_url
      t.string    :label_zpl_url

      t.timestamps
    end
  end
end
