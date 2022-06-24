# frozen_string_literal: true

require 'rails_helper'
require 'webmock/rspec'

RSpec.describe AdminController, type: :controller, omni: true do
  include Devise::Test::ControllerHelpers

  before :all do
     Repository.create(repository_id: 'paleontology', name: 'Test - Paleontology Collection')
  end

  let(:admin_user) { FactoryBot.create(:user, role = 'admin') }
  let(:manager_user) { FactoryBot.create(:user, role = 'manager') }
  let(:export_response_body) { File.open('./spec/fixtures/as_export.txt') }
  let(:zip_response_body) { File.open('./spec/fixtures/paleontology.zip') }
  let(:zip_response_headers) { { 'Content-Type' => 'application/zip' } }
  let(:aspace_export_url) { 'http://aspace.host/ead_export/' }

  before do
    request.env['devise.mapping'] = Devise.mappings[:user]
    request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:cas]
    ENV['ASPACE_EXPORT_URL'] = aspace_export_url
    stub_request(:get, aspace_export_url).to_return(export_response_body)
    stub_request(:get, "#{aspace_export_url}paleontology.zip")
      .to_return(status: 200, body: zip_response_body, headers: zip_response_headers)
  end

  OmniAuth.config.mock_auth[:cas] =
    OmniAuth::AuthHash.new(
      provider: 'cas',
      uid: 'jim_watson'
    )

  after do
    ENV['ASPACE_EXPORT_URL'] = 'http://localhost/assets/ead_export/'
  end

  context 'when user is unathenticated' do
    describe 'GET #index' do
      it 'redirects to sign-in page' do
        get :index
        expect(response).to be_redirect
        expect(response.redirect_url).to eq('http://test.host/users/auth/cas')
      end
    end
  end

  context 'when logged in as a manager user' do
    before do
      # Switch to Omniauth Controller for CAS authentication
      old_controller = @controller
      @controller = Users::OmniauthCallbacksController.new
      post :cas
      login_as manager_user
      @controller = old_controller
    end

    describe 'GET #index' do
      it 'redirects to dashboard' do
        expect(response.redirect_url).to eq 'http://test.host/admin'
      end

      it 'returns a success response' do
        valid_session = {}
        get :index, params: {}, session: valid_session
        expect(response).to be_successful
      end

      it 'indexes the users and repository' do
        get :index
        expect(assigns(:users)).to eq(User.all)
        expect(assigns(:repositories)).to eq(manager_user.repositories)
      end
    end

    describe 'GET #index_repositories' do
      it 'redirects to dashboard' do
        get :index_repository, params: { repository: 'lilly' }
        expect(response.redirect_url).to eq 'http://test.host/admin'
        expect(flash[:notice]).to eq 'These files are being indexed in the background and will be ready soon.'
      end
    end

    describe 'GET #index_ead' do
      it 'redirects to dashboard' do
        get :index_ead, params: { repository: 'lilly', ead: 'VAD4692.xml' }
        expect(response.redirect_url).to eq 'http://test.host/admin'
        expect(flash[:notice]).to eq 'The file is being indexed in the background and will be ready soon.'
      end
    end

    describe 'GET #delete_ead' do
      it 'redirects to dashboard' do
        get :delete_ead, params: { ead: 'VAD4692.xml' }
        expect(response.redirect_url).to eq 'http://test.host/admin'
        expect(flash[:notice]).to eq 'The file is being deleted in the background and will be removed soon.'
      end
    end
  end

  context 'when logged in as an admin user' do
    before do
      # Switch to Omniauth Controller for CAS authentication
      old_controller = @controller
      @controller = Users::OmniauthCallbacksController.new
      post :cas
      login_as admin_user
      @controller = old_controller
    end

    describe 'GET #index' do
      it 'redirects to dashboard' do
        expect(response.redirect_url).to eq 'http://test.host/admin'
      end

      it 'returns a success response' do
        valid_session = {}
        get :index, params: {}, session: valid_session
        expect(response).to be_successful
      end

      it 'indexes the users and repository' do
        get :index
        expect(assigns(:users)).to eq(User.all)
        expect(assigns(:repositories)).to eq(admin_user.repositories)
      end
    end

    describe 'GET #index_repositories' do
      it 'redirects to dashboard' do
        get :index_repository, params: { repository: 'lilly' }
        expect(response.redirect_url).to eq 'http://test.host/admin'
        expect(flash[:notice]).to eq 'These files are being indexed in the background and will be ready soon.'
      end
    end

    describe 'GET #index_ead' do
      it 'redirects to dashboard' do
        get :index_ead, params: { repository: 'lilly', ead: 'VAD4692.xml' }
        expect(response.redirect_url).to eq 'http://test.host/admin'
        expect(flash[:notice]).to eq 'The file is being indexed in the background and will be ready soon.'
      end
    end

    describe 'GET #delete_ead' do
      it 'redirects to dashboard' do
        get :delete_ead, params: { ead: 'VAD4692.xml' }
        expect(response.redirect_url).to eq 'http://test.host/admin'
        expect(flash[:notice]).to eq 'The file is being deleted in the background and will be removed soon.'
      end
    end
  end
end
