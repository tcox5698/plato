require 'rails_helper'

RSpec.describe "ideas/index", :type => :view do
  before(:each) do
    assign(:ideas, [
      Idea.create!(
        :name => "Name",
        :description => "Description",
        :profit_rating => 1,
        :skill_rating => 2,
        :passion_rating => 3
      ),
      Idea.create!(
        :name => "Name",
        :description => "Description",
        :profit_rating => 1,
        :skill_rating => 2,
        :passion_rating => 3
      )
    ])
  end

  it "renders a list of ideas" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td:nth-of-type(4)", :text => 1.to_s, :count => 2
    assert_select "tr>td:nth-of-type(5)", :text => 2.to_s, :count => 2
    assert_select "tr>td:nth-of-type(6)", :text => 3.to_s, :count => 2
  end
end
