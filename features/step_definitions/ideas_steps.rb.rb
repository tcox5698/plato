And(/^I visit the Ideas page$/) do
  visit '/ideas'
end

And(/^the following ideas$/) do |table|
  # table is a table.hashes.keys # => [:user_email, :idea_name]
  table.hashes.each do |row|
    # user = User.find_by_email row[:user]
    Idea.create! :name => row[:idea_name], :description => 'fake idea', :profit_rating => 1, :skill_rating => 1, :passion_rating => 1
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