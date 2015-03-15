require 'rails_helper'

describe HomeController, :type => :controller do
  describe "GET index" do
    before do
      get :index
    end

    describe 'response' do
      it 'should render template index' do
        expect(response).to render_template :index
      end
    end
  end
end