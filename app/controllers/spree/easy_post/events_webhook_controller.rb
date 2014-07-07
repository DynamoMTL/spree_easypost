module Spree
  module EasyPost
    class EventWebhooksController < ApplicationController
      require 'easypost'

      respond_to :json

      skip_before_filter :verify_authenticity_token, only: [:create]

      def create
        json = JSON.parse(request.body.read)
        e = EasyPost::Event.receive(JSON.pretty_generate(json))        
        easypost_event = EasypostEvent.new(
          description: e.description,
          mode: e.mode,
          easypost_id: e.id,
          object: e.object,
          mode: e.mode,
          result: e.result.to_s
        )
       
        if e.description == "tracker.updated"
          #process events
          shipment = ::Spree::Shipment.find_by_tracking(e.result.tracking_code)
          easypost_event.shipment = shipment if shipment
        end
        
        easypost_event.save    

        render nothing: true, status: 200
      end

    end
  end
end
