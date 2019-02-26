class PricingController < ApplicationController
  layout "subscribe"
  
  def index
    @plans = Stripe::Plan.list( product: Stripe_product_id )[:data]
  end
end
