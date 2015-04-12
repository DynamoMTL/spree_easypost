require 'spec_helper'

describe Spree::Address do
  it "doesn't validate non-USA address" do
    expect(EasyPost::Address).to_not receive(:create_and_verify)

    canada = create(:country, iso: 'CA')
    address = build(:address, country: canada)
    address.save
  end

  context "validating USA address" do
    let(:usa) { create(:country, iso: 'US') }

    it "considers invalid, when not found" do
      expect(EasyPost::Address).to receive(:create_and_verify).and_raise(EasyPost::Error.new("Address Not Found", 400))
      address = build(:address, country: usa )

      expect(address).to be_invalid
      expect(address.errors[:base]).to eq(['Address Not Found'])
    end

    it "considers invalid, when message returned" do
      response = stub(message: "Whooops")
      expect(EasyPost::Address).to receive(:create_and_verify).and_return(response)
      address = build(:address, country: usa )

      expect(address).to be_invalid
      expect(address.errors[:base]).to eq(['Whooops'])
    end
  end
end
