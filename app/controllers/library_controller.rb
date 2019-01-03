class LibraryController < ApplicationController
  before_action :authenticate_user!

  def index
    customer = Stripe::Customer.retrieve(current_user.stripe_id)
    subscription = customer.subscriptions.retrieve(current_user.stripe_subscription_id)
    @plan = subscription.items.data.first.plan
  end
end
