class Admin::CustomersController < ApplicationController
  def index
    @search = User.ransack(params[:q])
    @users = @search.result
  end

  def show
    @user = User.find(params[:id])
    if @user.subscribed?
      customer = Stripe::Customer.retrieve(@user.stripe_id)
      subscription = customer.subscriptions.retrieve(@user.stripe_subscription_id)
      @subscribed_items = subscription.items.data
    end
  end
end
