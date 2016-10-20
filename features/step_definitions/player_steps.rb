Given(/^I am on the quiz "([^"]*)" page$/) do |page|
  case page
  when 'landing'
    visit quiz_index_path
  end
end

And(/^I enter the code for "([^"]*)"$/) do |quiz|
  quiz = Quiz.find_by(name: quiz)
  fill_in :code, with: quiz.code
  click_link_or_button 'Submit'
end

Then(/^I should be on the quiz page for "([^"]*)"$/) do |quiz|
  quiz = Quiz.find_by(name: quiz)
  expect(current_path).to eq quiz_path(quiz)
end

Then(/^I am on the quiz page for "([^"]*)"$/) do |quiz|
  quiz = Quiz.find_by(name: quiz)
  visit quiz_path(quiz)
end

And(/^I should see a Create Team form$/) do
  expect(page).to have_css('form#create_team')
end

Given /^there is a "([^\"]+)" cookie set to "([^\"]+)"$/ do |key, value|
  team_id = Team.find_by(name: value).id
  case Capybara.current_session.driver
  when Capybara::Poltergeist::Driver
    page.driver.set_cookie(key, team_id)
  when Capybara::RackTest::Driver
    headers = {}
    Rack::Utils.set_cookie_header!(headers, key, team_id)
    cookie_string = headers['Set-Cookie']
    Capybara.current_session.driver.browser.set_cookie(cookie_string)
  else
    raise "no cookie-setter implemented for driver #{Capybara.current_session.driver.class.name}"
  end
end

Then(/^there should be a "([^"]*)" cookie set to the ID of "([^"]*)"$/) do |key, team_name|
  #cookie = Capybara.current_session.cookies_hash[key]
  #cookie = Capybara.current_session.driver.request.cookies.[](key)
  #team_id = Team.find_by(name: team_name).id
  #expect(cookie.to_i).to eq team_id
end

And(/^there is a team named "([^"]*)"$/) do |name|
  FactoryGirl.create(:team, name: name)
end