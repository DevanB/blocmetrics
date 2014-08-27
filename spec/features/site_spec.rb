require_relative '../../app'
require 'spec_helper'

describe "App", :type => :feature do
  include Rack::Test::Methods
  include UserFlowHelpers
  Capybara.app = App

  before do
    MongoCleaner.clean
  end

  def app
    App
  end

  it "should allow user to create site after signing in" do
    signup_and_signin("test@test.com", "testpassword", "testpassword")

    add_site("http://www.test.com")

    expect(page).to have_content("Successfully added site.")
    expect(page).to have_content("http://www.test.com")
  end

  it "should not allow user to create a site without being logged in" do
    visit "/site/new"

    expect(page).to have_content("Not authorized. Please login first.")
  end

  it "should not allow a blank url to be added as a site" do
    signup_and_signin("test@test.com", "testpassword", "testpassword")

    add_site("")

    expect(page).to have_content("Please specify a valid URL.")
  end

  it "should not allow a non-url value to be added as a site" do
    signup_and_signin("test@test.com", "testpassword", "testpassword")

    add_site("http://badurl@url")

    expect(page).to have_content("Please specificy a valid URL.")
  end

  it "should not allow a URL that is already a site to be added as a site" do
    signup_and_signin("test@test.com", "testpassword", "testpassword")

    add_site("http://www.testurl.com")

    expect(page).to have_content("Successfully added site.")
    expect(page).to have_content("http://www.testurl.com")

    add_site("http://www.testurl.com")

    expect(page).to have_content("URL is already in use.")
  end
end