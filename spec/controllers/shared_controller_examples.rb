require 'rspec'

RSpec.shared_examples 'a controller get action when user is not authenticated' do |controller_action|
  let(:user_authenticated) { false }
  before do
    get controller_action, request_params
  end
  describe 'the response' do
    it 'redirects to login page and alerts user they need to login' do
      expect(response).to redirect_to '/login'
      expect(flash[:alert]).to eq 'Please login first'
    end
  end
end