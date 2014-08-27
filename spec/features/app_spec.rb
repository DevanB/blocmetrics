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

  it "should increase page_count" do
    get '/'
    expect(last_response.body).to have_content("Hello World 1")
    get '/'
    expect(last_response.body).to have_content("Hello World 2")
  end

  it "should allow user to create site after signing in" do
    goto_signup
    submit_signup("test@test.com", "testpassword", "testpassword")
    
    goto_signin
    submit_signin("test@test.com", "testpassword")
    
    expect(page).to have_content("Successfully signed in.")

    click_link "Add Site"
    fill_in "url", with: "http://www.test.com"
    click_button "Add Site"

    expect(page).to have_content("Successfully added site.")
    expect(page).to have_content("http://www.test.com")
  end
end