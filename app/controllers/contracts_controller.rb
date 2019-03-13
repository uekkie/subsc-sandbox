class ContractsController < ApplicationController
  before_action :set_user_by_email, only: %i(edit)
  before_action :validates_customer, only: %i(edit)
  before_action :set_user, only: %i(create)

  def edit
    plans = Stripe::Plan.list( product: ENV['STRIPE_AOK_CLOUD_PRODUCT_ID'] )[:data]
    @plan = plans.first
  end

  def create
    plan_id = params[:plan_id]
    plan = Stripe::Plan.retrieve(plan_id)
    token = params[:stripeToken]

    customer = Stripe::Customer.retrieve(@user.stripe_id)
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

    @user.update(options)

    redirect_to thanks_contracts_url, notice: "メンバーシップが開始されました"
  end

  def destroy
  end

  def thanks
  end

  private
  def set_user_by_email
    @user = User.find_by_email("#{params[:id]}@aok.com")
  end
  def validates_customer
    redirect_to pricing_index_url, alert: '無効な顧客IDです' unless @user.try(:stripe_id)
  end
  def set_user
    @user = User.find_by_stripe_id!(params[:customer_id])
  end
end
