require_relative '../../app'
require 'spec_helper'

describe "Users", :type => :feature do
  include Rack::Test::Methods
  Capybara.app = App

  before do
    MongoCleaner.clean
  end

  def app
    App
  end

  it "should sign up and be redirected to sign in form if details are correct" do
    visit '/'
    within('.user-info') do
      click_link "Sign Up"
    end
    
    fill_in 'email', with: 'devan.beitel@gmail.com'
    fill_in 'password', with: 'testpassword'
    fill_in 'passwordConfirmation', with: 'testpassword'
    click_button 'Sign Up'

    expect(page).to have_content("Successfully signed up!")
  end

  it "should redirect if user email is already in use" do
    visit '/'
    within('.user-info') do
      click_link "Sign Up"
    end

    fill_in 'email', with: 'devan.beitel@gmail.com'
    fill_in 'password', with: 'testpass'
    fill_in 'passwordConfirmation', with: 'testpass'
    click_button 'Sign Up'

    within('.user-info') do
      click_link "Sign Up"
    end

    fill_in 'email', with: 'devan.beitel@gmail.com'
    fill_in 'password', with: 'testpass'
    fill_in 'passwordConfirmation', with: 'testpass'
    click_button 'Sign Up'

    expect(page).to have_content("Email address already registered.")
  end

  it "should redirect if passwords do not match" do
    visit '/'
    within('.user-info') do
      click_link "Sign Up"
    end

    fill_in 'email', with: 'devan.beitel@gmail.com'
    fill_in 'password', with: 'testpass'
    fill_in 'passwordConfirmation', with: 'testpassword'
    click_button 'Sign Up'

    expect(page).to have_content("Password and password confirmation do not match.")
    expect(page).to have_selector("input[value='devan.beitel@gmail.com']")
  end
end