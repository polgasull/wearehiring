require 'rails_helper'

RSpec.describe JobsController, type: :controller do
  describe 'GET #index' do
    let(:current_user) { FactoryBot.create(:user) }

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

  describe 'POST #create' do
    let(:current_user) { FactoryBot.create(:user) }

    before do
      sign_in current_user
    end

    it 'redirects to new_user_session_path when no current user' do
      sign_out current_user
      get :create
      expect(response).to redirect_to new_user_session_path
    end

    context 'creates a new job' do
      let(:valid_params) { FactoryBot.attributes_for(:job) }

      it 'creates a new Job' do
        binding.pry
        expect do
          post :create, params: { job: valid_params }
        end.to change(Job, :count).by(1)
      end

      it 'has a flash success' do
        post :create, params: { job: valid_params }
        expect(flash[:success]).to be_present
      end
    end
  end

  describe 'PATCH #update' do
    let(:current_user) { FactoryBot.create(:user) }
    let!(:job) { FactoryBot.create(:job) }
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

  describe 'DELETE #destroy' do
    let(:current_user) { FactoryBot.create(:user) }
    let!(:job) { FactoryBot.create(:job) }

    before do
      sign_in current_user
    end

    it 'redirects to new_user_session_path when no current user' do
      sign_out current_user
      delete :destroy, params: { id: job.id }
      expect(response).to redirect_to new_user_session_path
    end

    context 'destroys jobs' do
      it 'reduces count of jobs' do
        expect do
          delete :destroy, params: { id: job.id }
        end.to change(Job, :count).by(-1)
      end
    end

    context 'job not found' do
      it 'has flash error' do
        delete :destroy, params: { id: 0 }
        expect(flash[:error]).to be_present
      end
    end
  end
end