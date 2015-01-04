require 'rails_helper'

RSpec.describe "ideas/show", :type => :view do
  before(:each) do
    @idea = assign(:idea, Idea.create!(
      :name => "Name",
      :description => "Description",
      :profit_rating => 1,
      :skill_rating => 2,
      :passion_rating => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
  end
end
