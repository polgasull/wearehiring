# frozen_string_literal: true

module FilterBy
  extend ActiveSupport::Concern

  def filter_by(filtering_params = {})
    results = all
    filtering_params.each do |key, value|
      results = results.public_send(key, value) if value.present? && results.respond_to?(key)
    end

    results.order('created_at desc')
  end
end