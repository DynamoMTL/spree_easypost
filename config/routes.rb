Spree::Core::Engine.routes.draw do
  # Add your extension routes here  
  namespace :easy_post do
    resources :events
  end
end
