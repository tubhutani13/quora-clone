class TransactionsController < ApplicationController
  before_action :set_order, only: [:create]
  before_action :set_stripe_payment, only: [:create]

  def new
  end

  def create
    redirect_to @payment_session.create_payment_session.url, allow_other_host: true
  end

  private def set_order
    @order = Order.find(params[:order_id])
  end

  private def set_stripe_payment
    @payment_session = StripeChargesService.new(@order, current_user)
  end
end
