module Spree::AddressDecorator
  def self.prepended(klass)
    klass.validate :validate_address, if: :usa?
  end

  def usa?
    country.try(:iso) == 'US'
  end

protected
  def validate_address
    if address1_changed? || address2_changed? || city_changed? || state_id_changed? || state_name_changed? || country_id_changed? || zipcode_changed?
      Spree::EasyPost::AddressVerification.new(self).verify!
    end
  end
end

Spree::Address.prepend(Spree::AddressDecorator)
