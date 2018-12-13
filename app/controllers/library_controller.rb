class LibraryController < ApplicationController
  before_action :authenticate_user!

  def index
    @library_books = current_user.library_additions
    customer = Stripe::Customer.retrieve(current_user.stripe_id)
    subscription = customer.subscriptions.retrieve(current_user.stripe_subscription_id)
    @plan = subscription.items.data.first.plan
  end
end
