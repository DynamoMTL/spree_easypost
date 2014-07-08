Deface::Override.new(:virtual_path => 'spree/admin/orders/_shipment',
  :name => 'add_tracking_details_to_orders_edit',
  :insert_after => "div[data-hook=admin_shipment_form]",
  :text => '
    <fieldset class="no-border-bottom">
    <legend align="center">Tracking Details</legend>
    <% events = ::Spree::EasyPost::Event.where(order_id: order.id).order(created_at: :desc) %>
    <table>
    <thead>
      <tr>
        <th>Date</th>
        <th>Status</th>
        <th>Mode</th>
        <th>Details</th>
      </tr>
    </thead>
    <% events.each do |event| %>
      <% result = JSON.parse(event.result) %>
      <% tracking_details = event.result["tracking_details"] %>
      <tr>
        <td><%= DateTime.parse(result["created_at"]).strftime("%D") %></td>
        <td><%= result["mode"] %></td>
        <td><%= result["status"] %></td>
        <td>
          <% tracking_details = result["tracking_details"] %>
          <% tracking_details.each do |tracking| %>
            <b><%= DateTime.parse(tracking["datetime"]).strftime("%m/%d/%Y at %I:%M%p") %></b><br/>
            <%= tracking["message"] %><br/>
            Status: <%= tracking["status"] %><br/>
          <% end %>
        </td>
      </tr>
    <% end %> 
    </table>
    </fieldset>
  ')