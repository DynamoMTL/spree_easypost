module Spree
  module EasyPost
    class Shipment < Spree::Base
      self.table_name = 'easypost_shipments'
      belongs_to :order, class_name: 'Spree::Order'
      belongs_to :shipment, class_name: 'Spree::Shipment'
    end
  end
end