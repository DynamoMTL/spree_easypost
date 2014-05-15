Spree::ShippingRate.class_eval do
  def name
    read_attribute(:name)
  end
end