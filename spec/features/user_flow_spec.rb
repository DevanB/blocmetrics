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
end