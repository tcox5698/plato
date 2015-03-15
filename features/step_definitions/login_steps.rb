Then(/^I see the login page$/) do
  expect(page).to have_css 'h1', 'Login'
end