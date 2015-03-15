When(/^I am not logged in$/) do
end

And(/^I navigate to home page$/) do
  visit '/'
end

Then(/^I see the landing page$/) do
  expect(page).to have_content 'Plato'

  expect(page).not_to have_css '*.alert-danger'
  expect(page).not_to have_content 'Please login first'
  expect(page).to have_content 'Bring your ideas out of the cave!'

end

And(/^I see a login link$/) do
  expect(page).to have_link 'Login'
end