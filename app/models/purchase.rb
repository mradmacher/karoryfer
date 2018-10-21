# frozen_string_literal: true

class Purchase < ActiveRecord::Base
  MAX_DOWNLOADS = 7

  belongs_to :release

  after_initialize :generate_reference_id

  class PaymentError < StandardError
  end

  def self.create_payment(release, discount = nil)
    config_paypal(release.album.artist)
    price, currency = release.price_and_currency(discount)
    paypal_payment = PayPal::SDK::REST::Payment.new({
      intent: 'sale',
      payer: { payment_method: 'paypal' },
      redirect_urls: {
        return_url: 'https://www.karoryfer.com',
        cancel_url: 'https://www.karoryfer.com'
      },
      transactions: [{
        item_list: {
          items: [{
            name: release.album.title,
            price: price,
            currency: currency,
            quantity: 1
          }]
        },
        amount: {
          total: price,
          currency: currency
        },
        description: release.album.artist.name
      }]
    })
    if paypal_payment.create
      paypal_payment.id
    else
      raise PaymentError, paypal_payment.error
    end
  end

  def self.execute_payment(release, payment_id, payer_id, ip)
    config_paypal(release.album.artist)
    paypal_payment = PayPal::SDK::REST::Payment.find(payment_id)
    paypal_payment.execute(payer_id: payer_id)
    Purchase.create(payment_id: payment_id, ip: ip, release_id: release.id)
  end

  def self.config_paypal(artist)
    PayPal::SDK::REST.set_config(
      mode: Rails.env.production? ? 'live' : 'sandbox',
      client_id: artist.paypal_id,
      client_secret: artist.paypal_secret
    )
  end

  def downloads_exceeded?
    downloads >= MAX_DOWNLOADS
  end

  private

  def generate_reference_id
    self.reference_id = SecureRandom.hex if reference_id.nil?
  end
end
