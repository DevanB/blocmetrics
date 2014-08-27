require_relative '../../app'
require 'spec_helper'

describe "Users", :type => :feature do
  include Rack::Test::Methods
  include UserFlowHelpers
  Capybara.app = App

  before do
    MongoCleaner.clean
  end

  def app
    App
  end

  it "should sign up and be redirected to sign in form if details are correct" do
    goto_signup
    submit_signup("test@test.com","testpassword", "testpassword")

    expect(page).to have_content("Successfully signed up!")
  end

  it "should redirect if user email is already in use" do
    goto_signup
    submit_signup("test@test.com","testpassword", "testpassword")

    goto_signup
    submit_signup("test@test.com","testpassword", "testpassword")

    expect(page).to have_content("Email address already registered.")
  end

  it "should redirect if passwords do not match" do
    goto_signup
    submit_signup("test@test.com","testpassword", "badpassword")

    expect(page).to have_content("Password and password confirmation do not match.")
    expect(page).to have_selector("input[value='test@test.com']")
  end

  it "should sign-in if credentials are correct and display user email and sign out option" do
    signup_and_signin("test@test.com", "testpassword", "testpassword")
  end

  it "should not sign-in if credentials are not correct" do
    goto_signup
    submit_signup("test@test.com", "testpassword", "testpassword")

    goto_signin
    submit_signin("test@test.com", "badpassword")

    expect(page).to have_content("Email and/or password not valid. Please try again.")
  end

  it "should not sign-in if wrong email is given" do
    goto_signup
    submit_signup("test@test.com", "testpassword", "testpassword")

    goto_signin
    submit_signin("bademail@test.com", "testpassword")
    
    expect(page.status_code).to eq(200)
    expect(page).to have_content("Email and/or password not valid. Please try again.")
  end

  it "should successfully sign out" do
    signup_and_signin("test@test.com", "testpassword", "testpassword")

    within('.user-info') do
      click_button "Sign Out"
    end

    expect(page).to have_content("Successfully signed out.")
    expect(page).to_not have_content("Welcome test@test.com")
  end
end