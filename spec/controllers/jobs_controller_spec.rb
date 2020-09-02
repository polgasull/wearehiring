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
  end

  describe 'GET #show' do
    let(:company_type) { FactoryBot.create(:user_type, :company_type) }
    let(:current_user) { FactoryBot.create(:user, user_type: company_type) }
    let(:job) { FactoryBot.create(:job, :full_time, :junior, :product, user_id: current_user.id, expiry_date: DateTime.now() + 60.days )}

    before do
      sign_in current_user
    end

    it 'returns http success' do
      get :show, params: { id: job.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #edit' do
    let(:company_type) { FactoryBot.create(:user_type, :company_type) }
    let(:current_user) { FactoryBot.create(:user, user_type: company_type) }
    let(:job) { FactoryBot.create(:job, :full_time, :junior, :product, user_id: current_user.id )}
    let(:another_user) { FactoryBot.create(:user, user_type: company_type) }
    let(:another_job) { FactoryBot.create(:job, :full_time, :junior, :product, user_id: another_user.id )}

    before do
      sign_in current_user
    end

    it 'returns http success' do
      get :edit, params: { id: job.id }
      expect(response).to have_http_status(:success)
    end

    it 'redirects to new_user_session_path when no current user' do
      sign_out current_user
      get :edit, params: { id: job.id }
      expect(response).to redirect_to new_user_session_path
    end

    it 'redirects to root_path when job is not current_user job' do
      get :edit, params: { id: another_job.id }
      expect(response).to redirect_to root_path
    end

    context "user is candidate" do
      let(:candidate_type) { FactoryBot.create(:user_type, :candidate_type) }
      let(:candidate_user) { FactoryBot.create(:user, user_type: candidate_type) }
      let!(:candidate_job) { FactoryBot.create(:job, :full_time, :junior, :product, user_id: candidate_user.id )}

      it 'redirects to root_path when user is not company' do
        get :edit, params: { id: candidate_job.id }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'PATCH #update' do
    let(:company_type) { FactoryBot.create(:user_type, :company_type) }
    let(:current_user) { FactoryBot.create(:user, user_type: company_type) }
    let(:another_user) { FactoryBot.create(:user, user_type: company_type) }
    let(:job) { FactoryBot.create(:job, :full_time, :junior, :product, user_id: current_user.id, title: 'specific job' ) }
    let(:another_job) { FactoryBot.create(:job, :full_time, :junior, :product, user_id: another_user.id, title: 'specific job' )}
    let(:valid_params) { { title: 'general job' } }

    before do
      sign_in current_user
    end

    it 'updates Job' do
      patch :update, params: { id: job.id, job: valid_params }
      job.reload
      expect(job.title).to eq 'general job'
    end

    it 'redirects to new_user_session_path when no current user' do
      sign_out current_user
      patch :update, params: { id: job.id }
      expect(response).to redirect_to new_user_session_path
    end

    it 'redirects to root_path when job is not current_user job' do
      patch :update, params: { id: another_job.id }
      expect(response).to redirect_to root_path
    end

    context "user is candidate" do
      let(:candidate_type) { FactoryBot.create(:user_type, :candidate_type) }
      let(:candidate_user) { FactoryBot.create(:user, user_type: candidate_type) }
      let(:candidate_job) { FactoryBot.create(:job, :full_time, :junior, :product, user_id: candidate_user.id )}

      it 'redirects to root_path when user is not company' do
        patch :update, params: { id: candidate_job.id }
        expect(response).to redirect_to root_path
      end
    end
  end
end