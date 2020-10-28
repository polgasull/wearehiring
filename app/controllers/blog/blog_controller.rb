# frozen_string_literal: true

module Blog
  class BlogController < ApplicationController

    def index
      render body: nil
    end
  end
end