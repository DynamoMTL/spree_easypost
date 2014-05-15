# Spree + EasyPost

This is an extension to integrate Easy Post into Spree. Due to how it works, you will not be able to use any other extension than this for shipping methods. Your own shipping methods will not work, either. But the good thing is that you won't have to worry about that, because Easy Post handles it all for you.

You will need to [sign up for an account](https://www.easypost.com/) to use this extension.

## Installation

This goes in your `Gemfile`:

   gem 'spree_easypost', github: 'radar/spree_easypost', branch: '2-0-stable'

This goes in your terminal:

   rake railties:install:migrations
   rake db:migrate

This goes into a new file called `config/initializers/easy_post.rb`:

    EasyPost.api_key = 'YOUR_API_KEY_HERE'

## Usage

This extension hijacks `Spree::Stock::Estimator#shipping_rates` to calculate shipping rates for your orders. This call happens during the checkout process, once the order's address information has been provided.

The extension also adds a callback to the "ship" event on the `Shipment` model, telling EasyPost which rate was selected and "buying" that rate.

## Issues

Please let me know if you find any issues in [the usual places](https://github.com/radar/spree_easypost/issues), with [the usual information](https://github.com/spree/spree/tree/master/CONTRIBUTING.md). 

