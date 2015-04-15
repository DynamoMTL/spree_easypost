Spree::ShippingRate.class_eval do
  def name
    read_attribute(:name)
  end
  
  def shipping_method_code
    name
  end

end
