require 'rails_helper'

RSpec.describe InscriptionsController, type: :controller do

  describe 'POST #create' do
    let(:company_user) { FactoryBot.create(:user, :company) }
    let(:candidate_user) { FactoryBot.create(:user, :candidate) }
    let(:job) { FactoryBot.create(:job, :full_time, :junior, :product, user_id: company_user.id ) }

    before do
      sign_in(candidate_user)
    end

    it 'routes correctly' do
      expect(post: "/jobs/1/inscriptions").to route_to('inscriptions#create', job_id: '1')
    end

    context 'successful' do
      let(:valid_params) { FactoryBot.attributes_for(:inscription, job_id: job.id, user_id: candidate_user.id ) }

      subject(:create_inscription) do
        post(:create, params: { use_route: '/jobs/', inscription: valid_params })
      end

      it 'creates an inscription' do
        expect do
          create_inscription
        end.to change(job.inscriptions, :count).by(1)
      end

      it 'redirects to job page' do
        create_inscription
        expect(response).to redirect_to("/jobs/#{job.id}")
      end
    end

    context 'job not found' do
      let(:valid_params) { FactoryBot.attributes_for(:inscription, job_id: 0, user_id: candidate_user.id ) }

      subject(:create_inscription) do
        post(:create, params: { use_route: '/jobs/', inscription: valid_params })
      end

      before do
        create_inscription
      end

      it 'has flash error' do
        expect(flash[:alert]).to be_present
      end

      it 'redirects to job page' do
        create_inscription
        expect(response).to redirect_to(root_path)
      end
    end

    context 'already inscribed' do
    end
  end
end
