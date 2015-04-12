class Spree::EasyPost::AddressVerification
  def initialize(address)
    @address = address
  end

  def verify!
    response = verify

    parse(response)
  rescue EasyPost::Error => e
    add_error(e.message)
  end

  def attributes
    {
      name:    @address.full_name,
      street1: @address.address1,
      street2: @address.address2,
      city:    @address.city,
      state:   @address.state.try(:abbr) || @address.state_name,
      zip:     @address.zipcode,
      country: @address.country.try(:iso),
      phone:   @address.phone
    }
  end

  def verify
    EasyPost::Address.create_and_verify(attributes)
  end

  def parse(response)
    if response.message.present?
      add_error(response.message)
    else
      @address.address1 = response.street1
      @address.address2 = response.street2
      @address.city     = response.city
      @address.state    = Spree::State.find_by_abbr(response.state)
      @address.zipcode  = response.zip
    end
  end

  def add_error(message)
    @address.errors.add(:base, message)
  end
end
