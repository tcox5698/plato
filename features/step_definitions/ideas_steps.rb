And(/^I visit the Ideas page$/) do
  visit '/ideas'
end

And(/^the following ideas$/) do |table|
  # table is a table.hashes.keys # => [:user_email, :idea_name]
  table.hashes.each do |row|
    user = User.find_by_email row[:user_email]
    idea = Idea.create! :name => row[:idea_name], :description => 'fake idea', :profit_rating => 1, :skill_rating => 1, :passion_rating => 1
    user.has_role! :owner, idea
  end
end

Then(/^I see only the following ideas$/) do |table|
  # table is a table.hashes.keys # => [:idea_name]
  table.hashes.each do |expected_row|
    find(:xpath, "//table/tbody/tr/td[text() = \"#{expected_row[:idea_name]}\"]")
  end

  all_actual_rows = all(:xpath, "//table/tbody/tr")

  expect(all_actual_rows.size).to eq table.hashes.size
end

When(/^I create idea '(.*)' as user '(.*)' with password '(.*)'$/) do |idea_name, email, password|
  click_link 'Logout' if page.has_link? 'Logout'
  visit '/'
  expect(page).to have_link 'Login'
  steps %Q{
        When I log in as '#{email}' with password '#{password}'
        }
  visit '/ideas/new'
  fill_in 'Name', :with => idea_name
  fill_in 'Description', :with => "#{idea_name}: fake description"
  fill_in 'Profit rating', :with => '1'
  fill_in 'Skill rating', :with => '1'
  fill_in 'Passion rating', :with => '1'
  click_button 'Create Idea'
  expect(page).to have_content 'Idea was successfully created.'
  expect(page).to have_content idea_name
end

When(/^I go directly to the idea '(.*)'$/) do |idea_name|
  idea = Idea.find_by_name idea_name
  visit "/ideas/#{idea.id}"
end

Then(/^I do not see idea '(.*)'$/) do |idea_name|
  expect(page).not_to have_content idea_name
end

Then(/^I see the Ideas page$/) do
  expect(page).to have_content 'Ideas'
  expect(page).to have_content 'Profit rating'
end