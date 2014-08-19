require_relative '../../app'
require 'spec_helper'
require 'rack/test'
require 'pry'
require 'pry-debugger'
require_relative '../../database'


describe "Users", :type => :feature do
  include Rack::Test::Methods
  Capybara.app = App

  before do
  end

  def app
    App
  end

  it "should sign up and be redirected to sign in form if details are correct" do
    visit '/'
    within(".user-info") do
      click_link "Sign Up"
    end
    
    fill_in 'email', with: 'devan.beitel@gmail.com'
    fill_in 'password', with: 'testpassword'
    fill_in 'passwordConfirmation', with: 'testpassword'
    click_button 'Sign Up'

    expect(page).to have_content("Successfully signed up!")
  end
end