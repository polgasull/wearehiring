# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Blog::PostsController, type: :controller do
  describe 'GET #index' do
    let(:current_user) { FactoryBot.create(:user, :candidate) }

    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #show' do
    let(:post) { FactoryBot.create(:post)}

    it 'returns http success' do
      get :show, params: { id: post.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #edit' do
    let(:admin_type) { FactoryBot.create(:user_type, :admin_type) }
    let(:current_user) { FactoryBot.create(:user, user_type: admin_type) }
    let(:post) { FactoryBot.create(:post)}

    before do
      sign_in current_user
    end

    it 'returns http success' do
      get :edit, params: { id: post.id }
      expect(response).to have_http_status(:success)
    end

    it 'redirects to root_path when no admin' do
      sign_out current_user
      get :edit, params: { id: post.id }
      expect(response).to redirect_to root_path
    end
  end

  describe 'PATCH #update' do
    let(:admin_type) { FactoryBot.create(:user_type, :admin_type) }
    let(:candidate_type) { FactoryBot.create(:user_type, :candidate_type) }
    let(:current_user) { FactoryBot.create(:user, user_type: admin_type) }
    let(:another_user) { FactoryBot.create(:user, user_type: candidate_type) }
    let(:post) { FactoryBot.create(:post) }
    let(:valid_params) { { title: 'general post' } }

    before do
      sign_in current_user
    end

    it 'updates Post' do
      patch :update, params: { id: post.id, post: valid_params }
      post.reload
      expect(post.title).to eq 'general post'
    end

    it 'redirects to root_path when no current user' do
      sign_out current_user
      patch :update, params: { id: post.id }
      expect(response).to redirect_to root_path
    end

    it 'redirects to root_path when user is not admin' do
      sign_out current_user
      sign_in another_user

      patch :update, params: { id: post.id }
      expect(response).to redirect_to root_path
    end
  end
end