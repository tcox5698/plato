When(/^I am not logged in$/) do
end

And(/^I navigate to home page$/) do
  visit '/'
end

Then(/^I see the landing page$/) do
  expect(page).to have_content 'Plato'
end

And(/^I see a login link$/) do
  expect(page).to have_link 'Login'
end