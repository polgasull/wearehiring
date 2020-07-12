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
end
