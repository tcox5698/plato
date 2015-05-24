require 'rails_helper'

RSpec.describe UserSessionsController, :type => :controller do

  describe '#new' do
    let(:mock_new_user) { double 'mock_user' }
    before do
      allow(User).to receive(:new) { mock_new_user }
    end

    it 'renders the login page and assigns new user' do
      get :new
      expect(response).to render_template 'new'
      expect(assigns(:user)).to be mock_new_user
    end
  end

  describe '#create' do
      let(:input_email) { 'bob@secret.com' }
      let(:input_password) { 'secret!1' }

    context 'when sorcery login returns a user' do
      let(:mock_user) { double 'mock_user' }
      before do
        allow(controller).to receive(:login).with(input_email, input_password) { mock_user }
        post :create, { email: input_email, password: input_password }
      end
      it 'creates a session and redirects to landing page' do
        expect(assigns(:user)).to eq mock_user
        expect(response).to redirect_to '/'
      end
    end

    context 'when sorcery login returns nil' do
      before do
        allow(controller).to receive(:login).with(input_email, input_password) { nil }
        post :create, { email: input_email, password: input_password }
      end
      it 'renders the login page and displays error message' do
        expect(response).to render_template 'new'
        expect(flash[:alert]).to eq 'Login failed'
      end
    end
  end
end
