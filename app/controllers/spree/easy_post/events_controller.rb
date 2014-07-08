module Spree
  module EasyPost
    class EventsController < ApplicationController
      require 'easypost'

      respond_to :json

      skip_before_filter :verify_authenticity_token, only: [:create]

      # catch events webhooks from easy post
      def create
        json = JSON.parse(request.body.read)
        e = ::EasyPost::Event.receive(JSON.pretty_generate(json))        

        # prepare an easy post event object for persistence
        easypost_event = ::Spree::EasyPost::Event.new(
          description: e.description,
          mode: e.mode,
          easypost_id: e.id,
          object: e.object,
          mode: e.mode,
          result: e.result.to_s
        )
       
        # create a new event object
        if e.description == 'tracker.updated'
          # find the order id this is attached to
          easypost_spree_shipment = ::Spree::EasyPost::Shipment.find_by_easypost_id(e.result.shipment_id)
          #shipment = ::Spree::Shipment.find_by_tracking(e.result.tracking_code)
          easypost_event.order_id = easypost_spree_shipment.order_id if easypost_spree_shipment

          # send out shipping information when in transit
          if e.result.status == 'in_transit'
            shipment = easypost_spree_shipment.shipment
            ShipmentMailer.shipped_email(shipment.id).deliver
          end
        end
        
        easypost_event.save    

        render nothing: true, status: 200
      end

    end
  end
end
