# frozen_string_literal: true

module Admins
  class CandidatesController < Admins::AdminsController
    before_action :set_user, only: [:update, :inscriptions, :show, :edit]

    def index
      @candidates = User.candidates.filter_by(params).order('created_at DESC').page(params[:page]).per(30)
      @all = User.candidates.all
      @count = User.candidates.count
      @not_visible = User.candidates.where(visible: false).count
      @without_skills = User.candidates.without_skills.count

      respond_to do |format|
        format.html
        format.xlsx
      end
    end

    def show
      return redirect_to_response(t('not_found'), root_path, false) unless @candidate
    end

    def edit
      return redirect_to_response(t('not_found'), root_path, false) unless @candidate
    end

    def update
      if @candidate.update(user_params)
        redirect_back_response(t('users.messages.user_updated'))

        respond_to do |format|
          format.html
          format.js
        end
      else 
        redirect_back_response(t('users.messages.user_not_updated'), false)
      end
    end

    private

    def set_user
      @candidate = User.candidates.find(params[:id])
    end  

    def user_params
      params.require(:user).permit!
    end
  end
end
