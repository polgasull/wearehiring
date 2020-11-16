class SitemapsController < ApplicationController

  layout :false
  before_action :init_sitemap

  def index
    @jobs = Job.active.order('created_at DESC')
    @posts = Post.all.order('created_at DESC')
  end

  private

  def init_sitemap
    headers['Content-Type'] = 'application/xml'
  end

end