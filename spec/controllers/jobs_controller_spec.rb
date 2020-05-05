require 'rails_helper'

RSpec.describe JobsController, type: :controller do
  describe 'GET #index' do
    let(:current_user) { FactoryBot.create(:user, :company) }

    before do
      sign_in current_user
    end

    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'redirects to new_user_session_path when no current user' do
      sign_out current_user
      post :create
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe 'PATCH #update' do
    let(:current_user) { FactoryBot.create(:user, :company) }
    let(:job) { FactoryBot.create(:job, :full_time, :junior, :product, user_id: current_user.id, title: 'specific job' ) }
    let(:valid_params) { { title: 'general job' } }

    before do
      sign_in current_user
    end

    it 'redirects to new_user_session_path when no current user' do
      sign_out current_user
      patch :update, params: { id: job.id }
      expect(response).to redirect_to new_user_session_path
    end

    it 'updates Job' do
      patch :update, params: { id: job.id, job: valid_params }
      job.reload
      expect(job.title).to eq 'general job'
    end
  end
end