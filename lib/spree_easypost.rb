require 'spree_core'

module Spree
  module EasyPost
  end
end

require 'easypost'
EasyPost.api_key = 'CvzYtuda6KRI9JjG7SAHbA'

require 'spree_easypost/engine'
