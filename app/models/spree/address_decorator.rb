module Spree::AddressDecorator
  def self.prepended(klass)
    klass.validate :validate_address, if: :usa?
  end

  def usa?
    country.try(:iso) == 'US'
  end

protected
  def validate_address
    EasyPost::Address.create_and_verify(easy_post_attributes)
  rescue EasyPost::Error => e
    errors.add(:base, e.message)
  end

  def easy_post_attributes
    {
      name: full_name,
      street1: address1,
      street2: address2,
      city: city,
      state: state.try(:abbr) || state_name,
      zip: zipcode,
      country: country.try(:iso),
      phone: phone
    }
  end
end

Spree::Address.prepend(Spree::AddressDecorator)
