require 'rails_helper'

RSpec.describe UserSessionsController, :type => :controller do

  describe '#new' do
    it 'renders the login page' do
      expect(get(:new)).to render_template 'new'
    end

    it 'assigns a new user' do
      get :new
      expect(assigns(:user)).to be_a User
    end
  end

  describe '#create' do
    context 'when valid email and password posted' do
      let(:input_email) { 'bob@secret.com' }
      let(:input_password) { 'secret!1' }
      before do
        @user = User.create!(email: input_email, password: input_password, password_confirmation: input_password)
        post :create, { email: input_email, password: input_password }
      end
      it 'creates a session' do
        expect(assigns(:user)).to eq @user
      end
      it 'redirects to landing page' do
        expect(response).to redirect_to '/'
      end
    end

    context 'when invalid email and password posted' do
      before {post :create, { email: 'bob@here.com', password: 'secret' }}
      it 'renders the login page' do
        expect(response).to render_template 'new'
      end
      it 'displays login error message' do
        expect(flash[:alert]).to eq 'Login failed'
      end
    end
  end
end
