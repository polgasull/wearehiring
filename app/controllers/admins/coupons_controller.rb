# frozen_string_literal: true

module Admins
  class CouponsController < Admins::AdminsController
    before_action :set_coupon, only: [:update]

    def create
      coupon = Coupon.new(coupon_params)

      coupon.save ? 
        redirect_back_response(t('coupons.messages.coupon_updated')) : 
        redirect_back_response(t('coupons.messages.coupon_not_updated'), false)
    end

    def update
      @coupon.update(coupon_params) ? 
        redirect_to_response(t('coupons.messages.coupon_updated'), admins_settings_path) :
        redirect_back_response(t('coupons.messages.coupon_not_updated'), false)
    end

    private

    def set_coupon
      @coupon = Coupon.find(params[:id])
    end  

    def coupon_params
      params.require(:coupon).permit!
    end

  end
end