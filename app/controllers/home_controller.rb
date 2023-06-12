# frozen_string_literal: true

class HomeController < ApplicationController
  def robots
    respond_to :text
  end
end
