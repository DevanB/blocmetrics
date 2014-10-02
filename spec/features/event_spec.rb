require 'spec_helper'
require_relative '../../app'


describe "Events", :type => :feature do
  include Rack::Test::Methods
  include UserFlowHelpers
  Capybara.app = App

  before do
    MongoCleaner.clean
  end

  def app
    App
  end

  let(:user) {User.new("test@test.com", "testpassword", "testpassword")}
  let(:site) {Site.new(user, "http://test.com")}

  it "should allow post request with valid code" do
    SiteMapper.new($db).persist(site)
    post '/events', code: site.code, name: 'event name', property1: '2', property2: '6'
    expect(last_response.status).to eq(200)
  end

  it "should not allow post request with invalid code" do
    post '/events', code: '111111111111', name: 'event name', property1: '2', property2: '6'
    expect(last_response.status).to eq(404)
  end

  it "should be viewable" do
    Timecop.freeze(Time.new(2014, 10, 1, 7, 40)) do
      UserMapper.new($db).persist(user)
      SiteMapper.new($db).persist(site)

      post '/events', code: site.code, name: 'event name', property1: '2', property2: '6'
      expect(last_response.status).to eq(200)

      visit "/"
      goto_signin
      submit_signin("test@test.com", "testpassword")
      expect(page).to have_content("Successfully signed in.")

      within("#sites") do
        click_link "#{site.url}"
      end

      expect(page).to have_content("event name")
      expect(page).to have_content("2")
      expect(page).to have_content("6")
      expect(page).to have_content(Time.new(2014, 10, 1, 7, 40))
    end
  end
end

