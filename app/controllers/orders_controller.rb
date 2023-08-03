class OrdersController < ApplicationController
  before_action :set_credit_pack, only: [:create]
  before_action :set_order, only: [:checkout, :success, :failure]
  before_action :process_transaction, only: [:success, :failure]
  before_action :generate_transaction, only: [:success, :failure]
  before_action :update_user_credits, only: [:success]

  def create
    @order = Order.find_or_initialize_by(amount: @credit_pack.price, status: "in_cart", credit_pack: @credit_pack, user: current_user)
    if @order.save
      redirect_to checkout_order_path(@order.code)
    else
      redirect_to credit_packs_path, notice: t("failed_order")
    end
  end

  def checkout
  end

  def success
    @order.success!
  end

  def failure
    @order.failed!
  end

  private def set_credit_pack
    @credit_pack = CreditPack.find(params[:pack_id])
  end

  private def set_order
    @order = Order.find_by(code: params[:code])
  end

  private def process_transaction
    @payment_status = Stripe::Checkout::Session.retrieve({
      id: params[:transaction_id],
      expand: ["customer", "payment_intent"],
    })
    params[:code] = @payment_status.metadata.order_code
  rescue Stripe::InvalidRequestError
    redirect_to credit_packs_path, notice: t("invalid_transaction")
  end

  private def generate_transaction
    transaction_reason = transaction_status = nil
    if @payment_status.payment_intent.present?
      transaction_reason = @payment_status.payment_intent.last_payment_error.try(:message)
      transaction_status = @payment_status.payment_intent.try(:status)
    else
      transaction_reason = "unpaid"
    end

    @order_transaction = Transaction.find_or_initialize_by(transaction_id: @payment_status.id) do |transaction|
      transaction.order = @order
      transaction.amount = @payment_status.amount_total
      transaction.payment_method = @payment_status.payment_method_types[0]
      transaction.payment_status = @payment_status.payment_status
      transaction.reason = transaction_reason
      transaction.status = transaction_status
    end

    if @order_transaction.persisted?
      redirect_to credit_packs_path, notice: t("already_redeemed")
    else
      @order_transaction.save
    end
  end

  private def update_user_credits
    if @payment_status.payment_status == "paid"
      current_user.generate_credits(@order.credit_pack.credits, @order, 4)
    end
  end
end
