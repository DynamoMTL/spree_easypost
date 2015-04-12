require 'spec_helper'

describe Spree::Address do
  it "doesn't validate non-USA address" do
    expect(EasyPost::Address).to_not receive(:create_and_verify)

    address = build(:address, country: Spree::Country.find_by_iso('CA') )
    address.save
  end
end
