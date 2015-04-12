module Spree::AddressDecorator
  def self.prepended(klass)
    klass.validate :validate_address, if: :usa?
  end

  def usa?
    country.try(:iso) == 'US'
  end

protected
  def validate_address
    Spree::EasyPost::AddressVerification.new(self).verify!
  end
end

Spree::Address.prepend(Spree::AddressDecorator)
