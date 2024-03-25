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

  def formatted_price(price)
    if @user_country_code == "GB"
      content_tag(:span, "£#{price}")
    else
      content_tag(:span, "#{price} €")
    end
  end
end
