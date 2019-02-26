class SubscriptionsController < ApplicationController
  layout "subscribe"
  before_action :authenticate_user!, except: %i(index new create)
  before_action :check_subscriber, only: %i(new)
  before_action :set_customer, only: %i(index)

  def index
  end

  def new
  end

  def create
    plan_id = params[:plan_id]
    plan = Stripe::Plan.retrieve(plan_id)
    token = params[:stripeToken]

    customer = if current_user.stripe_id?
                Stripe::Customer.retrieve(current_user.stripe_id)
               else
                Stripe::Customer.create(email: current_user.email, source: token)
              end

    subscription = customer.subscriptions.create(plan: plan.id)

    options = {
      stripe_id: customer.id,
      stripe_subscription_id: subscription.id,
      subscribed: true
    }

    options.merge!(
      card_last4: params[:user][:card_last4],
      card_exp_month: params[:user][:card_exp_month],
      card_exp_year: params[:user][:card_exp_year],
      card_type: params[:user][:card_type]
    ) if params[:user][:card_last4]

    current_user.update(options)

    redirect_to root_path, notice: "Your subscription was setup successfully!"
  end

  def destroy
    customer = Stripe::Customer.retrieve(current_user.stripe_id)
    customer.subscriptions.retrieve(current_user.stripe_subscription_id).delete
    current_user.update(stripe_subscription_id: nil)
    current_user.subscribed = false

    redirect_to root_path, notice: "Your subscription has been cancelled."
  end

private
  def set_customer
    if user_signed_in? && current_user.stripe_id then
      customer = Stripe::Customer.retrieve(current_user.stripe_id)
      subscription = customer.subscriptions.retrieve(current_user.stripe_subscription_id)
      @plan = subscription.items.data.first.plan
    end
  end
  def check_subscriber
    if current_user.subscribed?
      redirect_to root_path, notice: "You are already a subscriber"
    end
  end
end
