require 'spec_helper'

describe 'Spree::Stock::Estimator customizations' do
  let!(:order) { create(:order_with_line_items, :line_items_count => 1) }
  it "can get rates from easy post" do
    order.refresh_shipment_rates
    rates = order.shipments.first.shipping_rates
    expect(rates.all? { |rate| rate.cost.present? }).to be_present
    expect(rates.all? { |rate| rate.easy_post_shipment_id? }).to be_present
    expect(rates.all? { |rate| rate.easy_post_rate_id? }).to be_present
  end
end