require 'spec_helper'

module Spree
  describe Shipment do
    let!(:order) { FactoryGirl.create(:order_with_line_items, :line_items_count => 1) }
    let!(:shipment) { order.shipments.first }

    it "'buys' a shipping rate after transitioning to ship" do
      shipment.refresh_rates
      shipment.state = 'ready'

      shipment.ship!
      expect(shipment.tracking).to be_present
    end
  end
end
