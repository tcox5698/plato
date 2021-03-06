Then(/^I see the Login page$/) do
  expect(page).to have_css 'h1', 'Login'
end

When(/^I log in as '(.*)' with password '(.*)'$/) do |email,password|
  visit '/login'
  fill_in 'Email', :with => email
  fill_in 'Password', :with => password
  click_button 'Login'
end

And(/^I see the 'Logout' link$/) do
  expect(page).to have_link 'Logout'
end