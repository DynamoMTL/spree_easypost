module Spree
  module EasyPost
    class PostageLabel < Spree::Base
      self.table_name = 'easypost_postage_labels'
      belongs_to :shipment    
    end
  end
end
