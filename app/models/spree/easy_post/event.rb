module Spree
  module EasyPost
    class Event < Spree::Base
      self.table_name = 'easypost_events'
      belongs_to :order, class_name: 'Spree::Order'
    end
  end
end