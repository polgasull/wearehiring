# frozen_string_literal: true

module ApplicationHelper
  def format_date(date)
    date&.strftime('%d/%m/%Y %H:%M')
  end

  def format_time(time)
    time&.respond_to?(:strftime) ? time.strftime('%H:%M') : time.to_s
  end

  def format_date_no_time(date)
    date&.strftime('%d/%m/%Y')
  end

  def alternate_locale_url(controller, action, params = {})
    options = { controller: "/#{controller}", action: action, locale: I18n.locale.to_s, only_path: true }
    additional_params = params

    merged_options = additional_params.present? ? options.merge(additional_params) : options

    url_for(merged_options)
  end
end
