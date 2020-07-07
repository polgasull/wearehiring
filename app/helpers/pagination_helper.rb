# frozen_string_literal: true

module PaginationHelper
  def infinite_scroll(collection)
    render(partial: 'paginator', locals: { collection: collection })
  end

  def render_next_scroll(partial, collection, options = {})
    alias_ = options.fetch(:alias)
    data = { collection: collection, partial: partial, alias_: alias_ }
    render(partial: 'next_paginated_page', locals: data)
  end
end