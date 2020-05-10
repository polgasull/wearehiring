class PagesController < ApplicationController
  
  def robots
    # Don't forget to delete /public/robots.txt
    respond_to :text
  end

end