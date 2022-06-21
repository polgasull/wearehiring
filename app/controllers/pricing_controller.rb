# frozen_string_literal: true

class PricingController < ApplicationController
  before_action :redirect_authenticated_users

  def index; end

  private

  def redirect_authenticated_users
    redirect_to root_path if user_signed_in?
  end
end
