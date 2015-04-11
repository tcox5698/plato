And(/^I see no error messages$/) do
  expect(page).not_to have_css '*.alert-danger '
end

And(/^I see the 'Please login' error message$/) do
  expect(page).to have_css '*.alert-danger ', 'Please Login'
end

Then(/^I see the error '(.*)'$/) do | error_message|
  expect(page).to have_content error_message
end