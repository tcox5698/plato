When(/^I visit the Users page$/) do
  visit '/users'
end

Given(/^the following users$/) do |table|
  # table is a table.hashes.keys # => [:email, :password]
  table.hashes.each do |user_row|
    User.create!(email: user_row[:email], password: user_row[:password], password_confirmation: user_row[:password])
  end
end


Then(/^I see only the following users listed$/) do |table|
  # table is a table.hashes.keys # => [:email]
  table.hashes.each do |expected_row|
    find(:xpath, "//table/tbody/tr/td[text() = '#{expected_row[:email]}']")
  end

  all_actual_rows = all(:xpath, "//table/tbody/tr")

  expect(all_actual_rows.size).to eq table.hashes.size
end