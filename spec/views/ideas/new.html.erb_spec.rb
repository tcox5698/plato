require 'rails_helper'

RSpec.describe "ideas/new", :type => :view do
  before(:each) do
    assign(:idea, Idea.new(
      :name => "MyString",
      :description => "MyString",
      :profit_rating => 1,
      :skill_rating => 1,
      :passion_rating => 1
    ))
  end

  it "renders new idea form" do
    render

    assert_select "form[action=?][method=?]", ideas_path, "post" do

      assert_select "input#idea_name[name=?]", "idea[name]"

      assert_select "input#idea_description[name=?]", "idea[description]"

      assert_select "input#idea_profit_rating[name=?]", "idea[profit_rating]"

      assert_select "input#idea_skill_rating[name=?]", "idea[skill_rating]"

      assert_select "input#idea_passion_rating[name=?]", "idea[passion_rating]"
    end
  end
end
