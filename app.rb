require "sinatra/base"
require "sinatra/reloader"
require_relative 'database'
require 'sinatra/flash'

$db = Database.new

class App < Sinatra::Base
  enable :sessions
  register Sinatra::Flash

  configure :development do
    register Sinatra::Reloader
  end

  get '/'  do
    $db.increment_page_count
    @page_count = $db.get_page_count
    erb :root, :layout => :layout
  end

  get '/users/sign-up' do
    erb :"users/sign-up", :layout => :layout
  end

  post '/users/sign-up' do
    #TODO - CHECK EMAIL FOR ALREADY IN USE?

    if params[:password] == params[:passwordConfirmation]
      #TODO - ENCRYPT PASSWORD
      $db.insert_user(params[:email], params[:password])
      flash[:notice] = "Successfully signed up!"
      redirect to("/users/sign-in")
    else
      #TODO - CARRY OVER EMAIL, MAYBE IN SESSIONS?
      flash[:error] = "Password and password confirmation do not match."
      redirect to("/users/sign-up")
    end
  end

  get '/users/sign-in' do
    erb "User Sign-In", :layout => :layout
  end
end