module Spree
  class PostageLabel < Spree::Base
    belongs_to :shipment    
  end
end
