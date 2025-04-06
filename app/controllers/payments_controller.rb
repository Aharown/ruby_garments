class PaymentsController < ApplicationController
  protect_from_forgery with: :null_session  # for API POSTs (adjust if needed)

  def create_checkout_session
    session = Stripe::Checkout::Session.create(
      ui_mode: 'embedded',
      line_items: [{
        price: params[:price_id],  # Pass this from your frontend
        quantity: 1
      }],
      mode: 'payment',
      return_url: "#{root_url}return.html?session_id={CHECKOUT_SESSION_ID}"
    )

    render json: { clientSecret: session.client_secret }
  end

  def session_status
    session = Stripe::Checkout::Session.retrieve(params[:session_id])
    render json: { status: session.status, customer_email: session.customer_details.email }
  end
end
