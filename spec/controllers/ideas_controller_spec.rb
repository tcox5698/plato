require 'rails_helper'

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
    { "warden.user.user.key" => session["warden.user.user.key"] }
  end

  let(:user_authenticated) { true }

  before do
    @user = User.create!(email: 'Bob@nancy.com', password: 'secret!1', password_confirmation: 'secret!1')
    login_user if user_authenticated
  end

  describe "GET index" do
    context 'when user is anonymous' do
      let(:user_authenticated) { false }
      it 'redirects to login page' do
        get :index, {}
        expect(response).to redirect_to '/login'
      end
    end

    context 'when user is authenticated' do
      before do
        @idea = Idea.create! valid_attributes
        get :index, {}, valid_session
      end

      it 'assigns all ideas as @ideas' do
        expect(assigns(:ideas)).to eq([@idea])
      end

      it 'renders the ideas template' do
        expect(response.status).to eq 200
        expect(response).to render_template :index
      end
    end
  end

  describe 'GET show' do
    context 'user is authenticated' do
      it 'assigns the requested idea as @idea' do
        idea = Idea.create! valid_attributes
        get :show, { :id => idea.to_param }, valid_session
        expect(assigns(:idea)).to eq(idea)
      end
    end
  end

  describe 'GET new' do
    it 'assigns a new idea as @idea' do
      get :new, {}, valid_session
      expect(assigns(:idea)).to be_a_new(Idea)
    end
  end

  describe "GET edit" do
    it "assigns the requested idea as @idea" do
      idea = Idea.create! valid_attributes
      get :edit, { :id => idea.to_param }, valid_session
      expect(assigns(:idea)).to eq(idea)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Idea" do
        expect {
          post :create, { :idea => valid_attributes }, valid_session
        }.to change(Idea, :count).by(1)
      end

      it "assigns a newly created idea as @idea" do
        post :create, { :idea => valid_attributes }, valid_session
        expect(assigns(:idea)).to be_a(Idea)
        expect(assigns(:idea)).to be_persisted
      end

      it "redirects to the created idea" do
        post :create, { :idea => valid_attributes }, valid_session
        expect(response).to redirect_to(Idea.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved idea as @idea" do
        post :create, { :idea => invalid_attributes }, valid_session
        expect(assigns(:idea)).to be_a_new(Idea)
      end

      it "re-renders the 'new' template" do
        post :create, { :idea => invalid_attributes }, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    let(:idea) { Idea.create! valid_attributes }

    before do
      put :update, { :id => idea.to_param, :idea => update_attributes }, valid_session
      idea.reload
    end

    context "with valid params" do
      let(:update_attributes) {
        { name: 'updated idea name', description: 'updated description', passion_rating: 2, skill_rating: 3, profit_rating: 4 }
      }

      it "updates the requested idea" do
        expect(idea[:name]).to eq update_attributes[:name]
        expect(idea[:description]).to eq update_attributes[:description]
        expect(idea[:passion_rating]).to eq update_attributes[:passion_rating]
        expect(idea[:skill_rating]).to eq update_attributes[:skill_rating]
        expect(idea[:profit_rating]).to eq update_attributes[:profit_rating]
      end

      it "assigns the requested idea as @idea" do
        expect(assigns(:idea)).to eq(idea)
      end

      it "redirects to the idea" do
        expect(response).to redirect_to(idea)
      end
    end

    context "with invalid params" do
      let(:update_attributes) {
        { name: nil }
      }

      it "assigns the idea as @idea" do
        expect(assigns(:idea)).to eq(idea)
      end

      it "re-renders the 'edit' template" do
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested idea" do
      idea = Idea.create! valid_attributes
      expect {
        delete :destroy, { :id => idea.to_param }, valid_session
      }.to change(Idea, :count).by(-1)
    end

    it "redirects to the ideas list" do
      idea = Idea.create! valid_attributes
      delete :destroy, { :id => idea.to_param }, valid_session
      expect(response).to redirect_to(ideas_url)
    end
  end

end
