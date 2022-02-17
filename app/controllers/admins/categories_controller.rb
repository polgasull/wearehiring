# frozen_string_literal: true

module Admins
  class CategoriesController < Admins::AdminsController
    before_action :set_category, only: [:update]

    def update
      @category.update(category_params) ? 
        redirect_to_response(t('categories.messages.category_updated'), admins_settings_path) :
        redirect_back_response(t('categories.messages.category_not_updated'), false)
    end

    private

    def set_category
      @category = Category.find(params[:id])
    end  

    def category_params
      params.require(:category).permit!
    end

  end
end
