require 'spree_core'

module Spree
  module EasyPost
    class PostageLabel < ActiveRecord::Base
      self.table_name = 'easypost_postage_labels'
      belongs_to :shipment    
    end

    class Shipment < ActiveRecord::Base
      self.table_name = 'easypost_shipments'
      belongs_to :order, class_name: 'Spree::Order'
      belongs_to :shipment, class_name: 'Spree::Shipment'
    end

    class Event < ActiveRecord::Base
      self.table_name = 'easypost_events'
      belongs_to :order, class_name: 'Spree::Order'
    end
  end
end

require 'easypost'
require 'spree_easypost/engine'
