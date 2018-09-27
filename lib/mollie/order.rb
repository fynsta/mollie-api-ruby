module Mollie
  class Order < Base
    STATUS_PENDING    = 'pending'
    STATUS_AUTHORIZED = 'authorized'
    STATUS_PAID       = 'paid'
    STATUS_SHIPPING   = 'shipping'
    STATUS_EXPIRED    = 'expired'
    STATUS_CANCELED   = 'canceled'
    STATUS_COMPLETED  = 'completed'
    STATUS_REFUNDED   = 'refunded'

    attr_accessor :id, :profile_id, :method, :mode, :amount, :amount_captured,
                  :amount_refunded, :status, :is_cancelable, :billing_address,
                  :consumer_date_of_birth, :order_number, :shipping_address,
                  :locale, :metadata, :redirect_url, :webhook_url, :created_at,
                  :expires_at, :expired_at, :paid_at, :authorized_at,
                  :canceled_at, :completed_at, :lines, :_links

    alias links _links

    def pending?
      status == STATUS_PENDING
    end

    def authorized?
      status == STATUS_AUTHORIZED
    end

    def paid?
      status == STATUS_PAID
    end

    def shipping?
      status == STATUS_SHIPPING
    end

    def expired?
      status == STATUS_EXPIRED
    end

    def canceled?
      status == STATUS_CANCELED
    end

    def completed?
      status == STATUS_COMPLETED
    end

    def refunded?
      status == STATUS_REFUNDED
    end

    def cancelable?
      is_cancelable
    end

    def checkout_url
      Util.extract_url(links, 'checkout')
    end

    def lines=(lines)
      @lines = lines.map { |line| Order::Line.new(line) }
    end

    def amount=(amount)
      @amount = Mollie::Amount.new(amount)
    end

    def amount_captured=(amount)
      @amount_captured = Mollie::Amount.new(amount)
    end

    def amount_refunded=(amount)
      @amount_refunded = Mollie::Amount.new(amount)
    end

    def billing_address=(address)
      @billing_address = OpenStruct.new(address) if address.is_a?(Hash)
    end

    def shipping_address=(address)
      @shipping_address = OpenStruct.new(address) if address.is_a?(Hash)
    end

    def metadata=(metadata)
      @metadata = OpenStruct.new(metadata) if metadata.is_a?(Hash)
    end

    def created_at=(created_at)
      @created_at = Time.parse(created_at.to_s)
    end

    def expires_at=(expires_at)
      @expires_at = Time.parse(expires_at.to_s)
    end

    def expired_at=(expired_at)
      @expired_at = Time.parse(expired_at.to_s)
    end

    def paid_at=(paid_at)
      @paid_at = Time.parse(paid_at.to_s)
    end

    def authorized_at=(authorized_at)
      @authorized_at = Time.parse(authorized_at.to_s)
    end

    def canceled_at=(canceled_at)
      @canceled_at = Time.parse(canceled_at.to_s)
    end

    def completed_at=(completed_at)
      @completed_at = Time.parse(completed_at.to_s)
    end

    def refunds(options = {})
      Order::Refund.all(options.merge(order_id: id))
    end

    def refund!(options = {})
      options[:order_id] = id
      options[:lines] ||= []
      Order::Refund.create(options)
    end
  end
end
