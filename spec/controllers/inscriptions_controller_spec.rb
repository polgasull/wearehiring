require 'rails_helper'

RSpec.describe InscriptionsController, type: :controller do

  describe 'POST #create' do
    let(:company_user) { FactoryBot.create(:user, :company) }
    let(:candidate_user) { FactoryBot.create(:user, :candidate) }
    let(:job) { FactoryBot.create(:job, :full_time, :junior, :product, user_id: company_user.id, id: '1' ) }

    before do
      sign_in(candidate_user)
    end

    it 'routes correctly' do
      expect(post: "/ofertas-empleo-digital/#{job.friendly_id}/inscriptions").to route_to('inscriptions#create', job_id: job.friendly_id)
    end

    context 'successful' do
      let(:valid_params) { FactoryBot.attributes_for(:inscription, user_id: candidate_user.id ) }

      subject(:create_inscription) do
        post(:create, params: { use_route: "/jobs/#{job.id}", inscription: valid_params, job_id: job.id })
      end

      let!(:job) { FactoryBot.create(:job, :full_time, :junior, :product, user_id: company_user.id ) }

      it 'creates an inscription' do
        expect do
          create_inscription
        end.to change(job.inscriptions, :count).by(1)
      end

      it 'redirects to job page' do
        create_inscription
        expect(response).to redirect_to("/ofertas-empleo-digital/#{job.friendly_id}")
      end
    end

    context 'Redirect back if candidate is already inscribed' do
      let(:valid_params) { FactoryBot.attributes_for(:inscription ) }

      subject(:create_inscription) do
        post(:create, params: { use_route: "/jobs/#{inscribed_job.id}", inscription: valid_params, job_id: inscribed_job.id })
      end

      let!(:inscribed_job) { FactoryBot.create(:job, :full_time, :junior, :product, user_id: company_user.id) }
      let!(:inscription) { FactoryBot.create(:inscription, job_id: inscribed_job.id, user_id: candidate_user.id) }

      it 'inscription is not created because user is already inscribed' do
        expect do
          create_inscription
        end.to change(inscribed_job.inscriptions, :count).by(0)
      end

      it 'redirects to Job page' do
        create_inscription
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
