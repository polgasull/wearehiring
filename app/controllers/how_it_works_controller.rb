# frozen_string_literal: true

class HowItWorksController < ApplicationController
  before_action :redirect_authenticated_users

  def companies; end

  def talent; end

  private

  def redirect_authenticated_users
    redirect_to root_path if user_signed_in?
  end

end
