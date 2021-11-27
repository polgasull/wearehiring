# frozen_string_literal: true

module Admins
  class PartnersController < Admins::AdminsController
    before_action :set_partner, only: [:update]

    def create
      partner = Partner.new(partner_params)

      partner.save ? 
        redirect_back_response(t('partners.messages.partner_updated')) : 
        redirect_back_response(t('partners.messages.partner_not_updated'), false)
    end

    def update
      @partner.update(partner_params) ? 
        redirect_to_response(t('partners.messages.partner_updated'), admins_settings_path) :
        redirect_back_response(t('partners.messages.partner_not_updated'), false)
    end

    private

    def set_partner
      @partner = Partner.find(params[:id])
    end  

    def partner_params
      params.require(:partner).permit!
    end

  end
end
