# frozen_string_literal: true

module PaymentHelper

  def stripe_process(price, discount)
    token = params[:stripeToken]
    job_type = params[:job_type]
    job_title = params[:title]
    card_brand = params[:user][:card_brand]
    card_exp_month = params[:user][:card_exp_month]
    card_exp_year = params[:user][:card_exp_year]
    card_last4 = params[:user][:card_last4]
    net_price = (price - discount)
    iva_tax = ((net_price * 0.0021) * 100).round
    irpf_tax = ((net_price * 0.0007) * 100).round
    price_after_taxes = net_price + iva_tax - irpf_tax

    charge = Stripe::Charge.create(
      :amount => price_after_taxes,
      :currency => 'eur',
      :description => job_type,
      :statement_descriptor => job_title,
      :source => token
    )

    current_user.stripe_id = charge.id
    current_user.card_brand = card_brand
    current_user.card_exp_month = card_exp_month
    current_user.card_exp_year = card_exp_year
    current_user.card_last4 = card_last4
    current_user.save!
  end
end
