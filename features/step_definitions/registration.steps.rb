And(/^I register user '(.*)' with password '(.*)'$/) do |email, password|
  visit '/users/new'
  expect(page).to have_content 'New user'
  fill_in 'Email', :with => email
  fill_in 'Password', :with => password
  fill_in 'Password confirmation', :with => password
  click_button 'Create User'
end