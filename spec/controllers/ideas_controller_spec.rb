require 'rails_helper'
require 'controllers/shared_controller_examples'

describe IdeasController, :type => :controller do

  let(:valid_attributes) {
    { name: 'idea name', passion_rating: 1, skill_rating: 2, profit_rating: 3 }
  }

  let(:invalid_attributes) {
    { name: nil }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # IdeasController. Be sure to keep this updated too.
  # let(:valid_session) { {} }

  def valid_session
    { 'warden.user.user.key' => session['warden.user.user.key'] }
  end

  let(:user_authenticated) { true }

  before do
    @user = User.create!(email: 'Bob@nancy.com', password: 'secret!1', password_confirmation: 'secret!1')
    @other_user = User.create!(email: 'nancy@here.com', password: 'secret!2', password_confirmation: 'secret!2')
    login_user(@user) if user_authenticated
  end

  describe 'GET index' do
    it_behaves_like 'a controller get action when user is not authenticated', :index do
      let(:request_params) { {} }
    end

    context 'when user is authenticated' do
      before do
        @idea = Idea.create! valid_attributes
        @user.has_role! :owner, @idea
        other_idea = Idea.create! valid_attributes
        @other_user.has_role! :owner, other_idea
        get :index, {}, valid_session
      end

      context 'when ideas from other users exists' do
        it "assigns only the user's ideas as @ideas" do
          expect(assigns(:ideas)).to eq([@idea])
        end
      end

      it 'renders the ideas template' do
        expect(response.status).to eq 200
        expect(response).to render_template :index
      end
    end
  end

  describe 'GET show' do
    let(:user_owns_idea) { false }
    before do
      @idea = Idea.create! valid_attributes
      @user.has_role!(:owner, @idea) if user_owns_idea
    end

    it_behaves_like 'a controller get action when user is not authenticated', :show do
      let(:request_params) { { :id => @idea.to_param } }
    end

    context 'user is authenticated' do
      before do
      begin
        get :show, { :id => @idea.to_param }, valid_session
      rescue => e
        @actual_exception = e
      end

    end
      context 'when user owns the requested idea' do
        let(:user_owns_idea) { true }
        it 'assigns the requested idea as @idea' do
          expect(assigns(:idea)).to eq(@idea)
        end

        it 'completes without exception' do
          expect(@actual_exception).to be_nil
        end
      end
      context 'when user does NOT own the requested idea' do
        describe 'the exception' do
          it 'is an Acl9::AccessDenied' do
            expect(@actual_exception.message).to eq 'Acl9::AccessDenied'
          end
        end
      end
    end
  end

  describe 'GET new' do
    it_behaves_like 'a controller get action when user is not authenticated', :new do
      let(:request_params) { {} }
    end

    it 'assigns a new idea as @idea' do
      get :new, {}, valid_session
      expect(assigns(:idea)).to be_a_new(Idea)
    end
  end

  describe 'GET edit' do
    before do
      @idea = Idea.create! valid_attributes
    end

    it_behaves_like 'a controller get action when user is not authenticated', :edit do
      let(:request_params) { { :id => @idea.to_param } }
    end

    context 'when user authenticated but requesting someone elses idea' do
      it 'raises access denied exception' do
        expect { get :edit, { :id => @idea.to_param }, valid_session }.to raise_exception Acl9::AccessDenied
      end
    end

    context 'when user authenticated and requesting own idea' do
      it 'assigns the requested idea as @idea' do
        @user.has_role! :owner, @idea
        get :edit, { :id => @idea.to_param }, valid_session
        expect(assigns(:idea)).to eq @idea
      end
    end
  end

  describe 'POST create' do
    before do
      expect(Idea.count).to eq 0
      post :create, { :idea => valid_attributes }, valid_session
    end
    context 'with valid params' do
      context 'when not authenticated' do
        let(:user_authenticated) { false }

        it 'redirects to login' do
          expect(response).to redirect_to login_path
        end
      end

      context 'when authenticated' do
        let(:user_authenticated) { true }
        it 'creates a new Idea' do
          expect(Idea.count).to eq 1
        end

        it 'assigns a newly created idea as @idea' do
          expect(assigns(:idea)).to be_a(Idea)
          expect(assigns(:idea)).to be_persisted
        end

        it 'assigns the current user as the owner of the idea' do
          idea = assigns(:idea)
          expect(idea).to be_a Idea
          expect(@user.has_role?(:owner, idea)).to be_truthy
        end

        it 'redirects to the created idea' do
          post :create, { :idea => valid_attributes }, valid_session
          expect(response).to redirect_to(Idea.last)
        end
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved idea as @idea' do
        post :create, { :idea => invalid_attributes }, valid_session
        expect(assigns(:idea)).to be_a_new(Idea)
      end

      it "re-renders the 'new' template" do
        post :create, { :idea => invalid_attributes }, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe 'PUT update' do
    let(:idea) { Idea.create! valid_attributes }
    let(:user_owns_idea) { true }

    before do
      @user.has_role!(:owner, idea) if user_owns_idea
      begin
        put :update, { :id => idea.to_param, :idea => update_attributes }, valid_session
      rescue => e
        @actual_exception = e
      end

      idea.reload
    end

    context 'when authenticated user does NOT own the idea' do
      let(:user_owns_idea) { false }
      let(:update_attributes) {
        { name: 'updated idea name', description: 'updated description', passion_rating: 2, skill_rating: 3, profit_rating: 4 }
      }
      it 'raises access denied exception' do
        expect(@actual_exception).to be_a Acl9::AccessDenied
      end
    end

    context 'when anonymous user' do
      let(:user_authenticated) { false }
      let(:update_attributes) {
        { name: 'updated idea name', description: 'updated description', passion_rating: 2, skill_rating: 3, profit_rating: 4 }
      }
      it 'redirects to login' do
        expect(response).to redirect_to login_path
      end
    end

    context 'when authenticated user owns the idea' do
      context 'with valid params' do
        let(:update_attributes) {
          { name: 'updated idea name', description: 'updated description', passion_rating: 2, skill_rating: 3, profit_rating: 4 }
        }

        it 'updates the requested idea' do
          expect(idea[:name]).to eq update_attributes[:name]
          expect(idea[:description]).to eq update_attributes[:description]
          expect(idea[:passion_rating]).to eq update_attributes[:passion_rating]
          expect(idea[:skill_rating]).to eq update_attributes[:skill_rating]
          expect(idea[:profit_rating]).to eq update_attributes[:profit_rating]
        end

        it 'assigns the requested idea as @idea' do
          expect(assigns(:idea)).to eq(idea)
        end

        it 'redirects to the idea' do
          expect(response).to redirect_to(idea)
        end
      end

      context 'with invalid params' do
        let(:update_attributes) {
          { name: nil }
        }

        it 'assigns the idea as @idea' do
          expect(assigns(:idea)).to eq(idea)
        end

        it "re-renders the 'edit' template" do
          expect(response).to render_template('edit')
        end
      end
    end
  end

  describe 'DELETE destroy' do
    let(:idea) { Idea.create! valid_attributes }
    before do
      @user.has_role! :owner, idea
    end
    context 'when authenticated user owns idea' do
      it 'destroys the requested idea' do
        expect {
          delete :destroy, { :id => idea.to_param }, valid_session
        }.to change(Idea, :count).by(-1)
      end

      it 'redirects to the ideas list' do
        delete :destroy, { :id => idea.to_param }, valid_session
        expect(response).to redirect_to(ideas_url)
      end
    end
  end
end
