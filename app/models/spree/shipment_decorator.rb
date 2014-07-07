Spree::Shipment.class_eval do
  state_machine.before_transition :to => :shipped, :do => :buy_easypost_rate
  has_one :postage_label, :class_name => 'Spree::EasyPost::PostageLabel'
           

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

    create_easypost_shipment(easypost_shipment)
    create_postage_label(easypost_shipment)    
  end

  def create_easypost_shipment(easypost_shipment)
    spree_easypost_shipment = ::Spree::EasyPost::Shipment.new
    spree_easypost_shipment.attributes = easypost_shipment.to_hash.reject{|k,v| !spree_easypost_shipment.attributes.keys.member?(k.to_s) || k.to_s == 'id' }      
    spree_easypost_shipment.easypost_id = easypost_shipment.id
    spree_easypost_shipment.order = self.order
    spree_easypost_shipment.shipment = self
    spree_easypost_shipment.save
  end

  def create_easypost_ostage_label(easypost_shipment)   
    response_attributes = JSON.parse(easypost_shipment.postage_label.to_s)

    postage_label = ::Spree::EasyPost::PostageLabel.new
    # assign attributes to our new postage label, ignoring those that are not defined on our model
    postage_label.attributes = response_attributes.reject{|k,v| !postage_label.attributes.keys.member?(k.to_s) || k.to_s == 'id' }      
    postage_label.easypost_id = response_attributes['id']
    # assign this to the current shipment
    postage_label.shipment = self
    postage_label.easypost_shipment_id = easypost_shipment.id
    postage_label.save
  end
end
