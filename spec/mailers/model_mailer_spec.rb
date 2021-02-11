require "rails_helper"

RSpec.describe ModelMailer, type: :mailer do
  describe 'new_job' do
    let(:user) { FactoryBot.create(:user, :company) }
    let(:job) { FactoryBot.create(:job, :junior, :product, :full_time, user_id: user.id)}
    let(:mail) { described_class.new_job(user, job) }

    it 'renders the subject' do
      expect(mail.subject).to eq("Congrats! Nuevo Job Publicado! 🥳")
    end

    it 'renders reciever' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders sender' do
      expect(mail.from).to eq(['hello@wearehiring.io'])
    end
  end

  describe 'new_candidate' do
    let(:user) { FactoryBot.create(:user, :company) }
    let(:job) { FactoryBot.create(:job, :junior, :product, :full_time, user_id: user.id)}
    let(:mail) { described_class.new_candidate(user, job) }

    it 'renders the subject' do
      expect(mail.subject).to eq("Tienes un nuevo candidato ✅")
    end

    it 'renders reciever' do
      expect(mail.to).to eq([job.user.email])
    end

    it 'renders sender' do
      expect(mail.from).to eq(['hello@wearehiring.io'])
    end
  end

  describe 'successfully_inscribed' do
    let(:user) { FactoryBot.create(:user, :candidate) }
    let(:job) { FactoryBot.create(:job, :junior, :product, :full_time, user_id: user.id)}
    let(:mail) { described_class.successfully_inscribed(user, job) }

    it 'renders the subject' do
      expect(mail.subject).to eq("Has solicitado el Job correctamente 💪")
    end

    it 'renders reciever' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders sender' do
      expect(mail.from).to eq(['hello@wearehiring.io'])
    end
  end

  describe 'new_job_scrapping' do
    let(:user) { FactoryBot.create(:user, :company) }
    let(:job) { FactoryBot.create(:job, :junior, :product, :full_time, :external_mail, user_id: user.id)}
    let(:mail) { described_class.new_job(user, job) }

    it 'renders the subject' do
      expect(mail.subject).to eq("Congrats! Nuevo Job Publicado! 🥳")
    end

    it 'renders reciever' do
      expect(mail.to).to eq([job.external_mail])
    end

    it 'renders sender' do
      expect(mail.from).to eq(['hello@wearehiring.io'])
    end
  end
end
