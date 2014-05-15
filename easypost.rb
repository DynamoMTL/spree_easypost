require 'easypost'
EasyPost.api_key = 'CvzYtuda6KRI9JjG7SAHbA'

to_address = EasyPost::Address.create(
  :name => 'Sawyer Bateman',
  :street1 => '830 Denman St.',
  :street2 => 'Apt 21',
  :city => 'Vancouver',
  :state => 'BC',
  :zip => 'V6G 2L8',
  :country => 'CA',
  :phone => '780-273-8374'
)

from_address = EasyPost::Address.create(
  :company => 'EasyPost',
  :street1 => '164 Townsend Street',
  :street2 => '#1',
  :city => 'San Francisco',
  :state => 'CA',
  :zip => '94107',
  :phone => '415-379-7678'
)

parcel = EasyPost::Parcel.create(
  :weight => 35.1
)

customs_item = EasyPost::CustomsItem.create(
  :description => 'EasyPost T-shirts',
  :quantity => 1,
  :value => 10,
  :weight => 13,
  :origin_country => 'us',
  :hs_tariff_number => 123456
)

customs_info = EasyPost::CustomsInfo.create(
  :integrated_form_type => 'form_2976',
  :customs_certify => true,
  :customs_signer => 'Dr. Pepper',
  :contents_type => 'gift',
  :contents_explanation => '', # only required when contents_type => 'other'
  :eel_pfc => 'NOEEI 30.37(a)',
  :non_delivery_option => 'abandon',
  :restriction_type => 'none',
  :restriction_comments => '',
  :customs_items => [customs_item]
)

shipment = EasyPost::Shipment.create(
  :to_address => to_address,
  :from_address => from_address,
  :parcel => parcel,
  :customs_info => customs_info
)

shipment.buy(
  :rate => shipment.lowest_rate
)

puts shipment.postage_label.label_url