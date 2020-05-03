# frozen_string_literal: true

module Admins
  class UsersController < Admins::AdminsController

    def index
      @users = User.all.order('created_at DESC')
    end 
  end
end