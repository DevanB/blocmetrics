require 'spec_helper'
require_relative '../../app'


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
end