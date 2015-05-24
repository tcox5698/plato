When(/^I am not logged in$/) do
end

And(/^I visit the Home page$/) do
  visit '/'
  expect(page).to have_content 'Bring your ideas out of the cave!'
end

Then(/^I see the landing page$/) do
  expect(page).to have_content 'Plato'

  expect(page).to have_no_css '*.alert-danger'
  expect(page).to have_no_content 'Please login first'
  expect(page).to have_content 'Bring your ideas out of the cave!'

end

And(/^I see a login link$/) do
  expect(page).to have_link 'Login'
end