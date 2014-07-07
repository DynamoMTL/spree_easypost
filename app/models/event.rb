module Spree
  module EasyPost
    class Event < Spree::Base
      belongs_to :order, class_name: 'Spree::Order'
    end
  end
end