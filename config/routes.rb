Spree::Core::Engine.routes.draw do
  # Add your extension routes here  
  post 'easypost_webhooks' => 'easypost_webhooks#create'
end
