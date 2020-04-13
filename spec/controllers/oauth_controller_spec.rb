require 'rails_helper'

describe OauthController, type: :controller do

  before(:each) do
    mock_auth_hash
    request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:linkedin]
  end

  after(:each) do
    OmniAuth.config.mock_auth[:linkedin] = nil
  end

  describe 'GET #callback' do
    it 'expects omniauth.auth to be be_truthy' do
      get :callback, provider: :linkedin
      expect(request.env['omniauth.auth']).to be_truthy
    end

    it 'completes the registration process successfully' do
      get :callback, provider: :linkedin
      expect(page).to redirect_to Config.provider_login_path
    end

    it 'creates an oauth_account record' do
      expect{
        get :callback, provider: :linkedin
      }.to change { OauthAccount.count }.by(1)
    end

  end

end