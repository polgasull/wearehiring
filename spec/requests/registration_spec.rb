require "rails_helper"

describe "home#register as a provider", :type => :request do

  it "redirects to oauth#callback" do
    get '/auth/linkedin'
    expect(response).to redirect_to(oauth_callback_path(:linkedin))
  end

end