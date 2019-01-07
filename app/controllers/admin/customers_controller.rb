class Admin::CustomersController < ApplicationController
  before_action :admin_signed_in

  def index
    @search = User.ransack(params[:q])
    @users = @search.result.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    if @user.subscribed?
      customer = Stripe::Customer.retrieve(@user.stripe_id)
      subscription = customer.subscriptions.retrieve(@user.stripe_subscription_id)
      @subscribed_items = subscription.items.data
    end
  end
  
  private
  def admin_signed_in
    unless view_context.admin?
      redirect_to root_path, notice: "管理者でログインしてください"
    end
  end
end
