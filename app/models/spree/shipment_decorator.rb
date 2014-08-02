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

    logger.debug 'Buying easypost rates...'
    begin
      easypost_shipment.buy(rate)    
      self.tracking = easypost_shipment.tracking_code

      create_easypost_shipment(easypost_shipment.to_hash)
      create_easypost_postage_label(easypost_shipment.to_hash)    

      logger.info "Receive postage label: #{easypost_shipment.postage_label.label_url}"
    rescue => e
      logger.error "Error when buying easypost reates: #{e}"      
    end
  end

  def after_ship
    inventory_units.each &:ship!
    # do not send shipment confirmation email to our customers 
    # we will do it when we receive the in_transit event from easy post later on. check Spree::EasyPost::EventsController
    # send_shipped_email 
    touch :shipped_at
    update_order_shipment_state
  end

  def create_easypost_shipment(easypost_shipment_attributes)
    spree_easypost_shipment = ::Spree::EasyPost::Shipment.new
    spree_easypost_shipment.attributes = easypost_shipment_attributes.reject{|k,v| !spree_easypost_shipment.attributes.keys.member?(k.to_s) || k.to_s == 'id' }      
    spree_easypost_shipment.easypost_id = easypost_shipment_attributes[:id]
    spree_easypost_shipment.order = self.order
    spree_easypost_shipment.shipment = self
    spree_easypost_shipment.save
  end

  def create_easypost_postage_label(easypost_shipment_attributes)   
    easypost_postage_label_attributes = easypost_shipment_attributes[:postage_label].to_hash
    
    spree_easypost_postage_label = ::Spree::EasyPost::PostageLabel.new
    # assign attributes to our new postage label, ignoring those that are not defined on our model
    spree_easypost_postage_label.attributes = easypost_postage_label_attributes.reject{|k,v| !spree_easypost_postage_label.attributes.keys.member?(k.to_s) || k.to_s == 'id' }      
    spree_easypost_postage_label.easypost_id = easypost_postage_label_attributes[:id]
    # assign this to the current shipment
    spree_easypost_postage_label.shipment_id = self.id
    spree_easypost_postage_label.easypost_shipment_id = easypost_shipment_attributes[:id]
    spree_easypost_postage_label.save
  end

  def logger
    @logger ||= Logger.new("#{Rails.root}/log/spree_easypost.log")
  end
end
