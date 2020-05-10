class SitemapsController < ApplicationController

  layout :false
  before_action :init_sitemap

  def index
    @jobs = Job.not_expired
  end

  private

  def init_sitemap
    headers['Content-Type'] = 'application/xml'
  end

end