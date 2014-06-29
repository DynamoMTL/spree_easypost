Spree::Shipment.class_eval do
  state_machine.before_transition :to => :shipped, :do => :buy_easypost_rate
  has_one :postage_label

  def tracking_url
    nil # TODO: Work out how to properly generate this
  end
  
  def shipping_method_with_easypost
    selected_shipping_rate
  end

  alias_method_chain :shipping_method, :easypost
  
  private

  def selected_easy_post_rate_id
    selected_shipping_rate.easy_post_rate_id
  end

  def selected_easy_post_shipment_id
    selected_shipping_rate.easy_post_shipment_id
  end

  def easypost_shipment
    @ep_shipment ||= EasyPost::Shipment.retrieve(selected_easy_post_shipment_id)
  end

  def buy_easypost_rate
    rate = easypost_shipment.rates.find do |rate|
      rate.id == selected_easy_post_rate_id
    end

    easypost_shipment.buy(rate)    
    self.tracking = easypost_shipment.tracking_code

    create_postage_label(easypost_shipment)    
  end

  def create_postage_label(shipment)   
    response_attributes = JSON.parse(shipment.postage_label.to_s)

    postage_label = ::Spree::PostageLabel.new
    # assign attributes to our new postage label, ignoring those that are not defined on our model
    postage_label.attributes = response_attributes.reject{|k,v| !postage_label.attributes.keys.member?(k.to_s) || k.to_s == 'id' }      
    postage_label.easypost_id = response_attributes['id']
    # assign this to the current shipment
    postage_label.shipment = self
    postage_label.save
  end
end
