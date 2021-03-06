require 'rails_helper'

describe UsersController, :type => :controller do
  let(:user_authenticated) { false }
  let(:other_users_exist) { false }

  before do
    @user = User.create!(email: 'Bob@nancy.com', password: 'secret!1', password_confirmation: 'secret!1')
    login_user if user_authenticated
    if other_users_exist
      @other_users = [User.create!(email: 'other_user@nancy.com', password: 'secret!1', password_confirmation: 'secret!1')]
    end
  end

  describe 'POST new' do
    before do
      post :create, { :user => { email: 'erg@blah.com', password: 'Password1!', password_confirmation: 'Password1!' } }
    end

    context 'when not authenticated' do
      it 'should redirect to ideas' do
        expect(response).to redirect_to '/login'
      end

      it 'should flash success' do
        expect(flash[:notice]).to eq 'User was successfully created.'
      end
    end
  end

  describe 'GET new' do
    before do
      get :new
    end

    context 'when not authenticated' do
      it 'should render the new user page' do
        expect(response).to render_template :new
      end

      it 'should return 200' do
        expect(response.code).to eq '200'
      end
    end
  end

  describe 'GET index' do
    before do
      get :index, {}
    end

    context 'when user is not authenticated' do
      it 'redirects to login page' do
        expect(response.code).to eq '302'
        expect(response).to redirect_to '/login'
      end

      it 'shows the please login error' do
        expect(flash[:alert]).to eq 'Please login first'
      end
    end

    context 'when user is authenticated' do
      let(:user_authenticated) { true }

      context 'when other users exist' do
        let(:other_users_exist) { true }

        it 'assigns the only the authenticated user' do
          expect(assigns(:users).map { |u| u }).to eq([@user])
        end
      end
    end
  end

  describe 'GET show' do
    let(:requested_user_id) { @user.to_param }


    context 'when user is not authenticated' do

      let(:user_authenticated) { false }
      before do
        get :show, { :id => requested_user_id }
      end
      describe 'the response' do
        it 'redirects to login page' do
          expect(response).to redirect_to '/login'
        end

        it 'notifies the user they need to login' do
          expect(flash[:alert]).to eq 'Please login first'
        end
      end
    end

    context 'when user is authenticated' do
      let(:user_authenticated) { true }
      context 'when requesting current user' do
        before do
          get :show, { :id => requested_user_id }
        end
        it 'assigns the current user' do
          expect(assigns(:user)).to eq @user
          expect(assigns(:users)).to be_nil
        end

        it 'renders the show template' do
          expect(response).to render_template :show
        end
      end

      context 'when requesting some other existing user' do
        let(:other_users_exist) { true }
        let(:requested_user_id) { @other_users[0].id.to_s }
        it 'throws 404 exception' do
          expect { get(:show, { :id => requested_user_id }) }.to raise_error(ActionController::RoutingError, 'Not found')
        end
      end
    end
  end
end