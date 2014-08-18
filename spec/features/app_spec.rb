require_relative '../../app'
require 'spec_helper'
require 'rack/test'
require 'pry'
require 'pry-debugger'
require_relative '../../database'


describe "App" do
  include Rack::Test::Methods

  before do
    db = Database.new
    db.clear_page_count
  end

  def app
    App
  end

  it "should increase page_count" do
    get '/'
    expect(last_response.body).to eq("Hello World 1")
    get '/'
    expect(last_response.body).to eq("Hello World 2")
  end 
end