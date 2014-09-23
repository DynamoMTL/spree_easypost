Spree::Stock::Estimator.class_eval do
  def shipping_rates(package)
    logger.debug '---estimating shipping rates---'
    logger.debug "package: #{package.inspect}"

    order = package.order

    from_address = process_address(package.stock_location)
    logger.debug "from_address: #{from_address.inspect}"

    to_address = process_address(order.ship_address)
    logger.debug "to_address: #{to_address.inspect}"

    parcel = build_parcel(package)
    logger.debug "parcel: #{parcel.inspect}"

    shipment = build_shipment(from_address, to_address, parcel)
    logger.debug "shipment: #{shipment.inspect}"

    rates = shipment.rates.sort_by { |r| r.rate.to_i }
    logger.debug "rates: #{rates.inspect}"    
    logger.debug '---end---'

    if rates.any?
      rates.each do |rate|
        package.shipping_rates << Spree::ShippingRate.new(
          :name => "#{rate.carrier} #{rate.service}",
          :cost => rate.rate,
          :easy_post_shipment_id => rate.shipment_id,
          :easy_post_rate_id => rate.id
        )
      end

      # Sets cheapest rate to be selected by default
      package.shipping_rates.first.selected = true

      package.shipping_rates
    else
      logger.info "No rates found."
      logger.info "package: #{package.inspect}"
      logger.info "from_address: #{from_address.inspect}"
      logger.info "to_address: #{to_address.inspect}"
      []
    end
  end

  private

  def process_address(address)
    ep_address_attrs = {}
    # Stock locations do not have "company" attributes,
    ep_address_attrs[:company] = if address.respond_to?(:company)
      address.company
    else
      Spree::Store.current.name
    end
    ep_address_attrs[:name] = address.full_name if address.respond_to?(:full_name)
    ep_address_attrs[:street1] = address.address1
    ep_address_attrs[:street2] = address.address2
    ep_address_attrs[:city] = address.city
    ep_address_attrs[:state] = address.state ? address.state.abbr : address.state_name
    ep_address_attrs[:zip] = address.zipcode
    ep_address_attrs[:phone] = address.phone

    ::EasyPost::Address.create(ep_address_attrs)
  end

  def build_parcel(package)
    total_weight = package.contents.sum do |item|
      item.line_item.quantity * item.variant.weight
    end

    parcel = ::EasyPost::Parcel.create(
      :weight => total_weight
    )
  end

  def build_shipment(from_address, to_address, parcel)
    shipment = ::EasyPost::Shipment.create(
      :to_address => to_address,
      :from_address => from_address,
      :parcel => parcel
    )
  end

  def logger
    @logger ||= Logger.new("#{Rails.root}/log/spree_easypost.log")
  end  

end
