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
    erb :"users/sign-up", :layout => :layout, :locals => { :email => "" }
  end

  post '/users/sign-up' do
    if $db.check_email_for_signup(params[:email])
      flash[:fatal] = "Email address already registered."
      redirect to('/users/sign-up')
      return
    end

    if params[:password] == params[:passwordConfirmation]
      #TODO - ENCRYPT PASSWORD
      $db.insert_user(params[:email], params[:password])
      flash[:info] = "Successfully signed up!"
      redirect to("/users/sign-in")
    else
      flash.now[:fatal] = "Password and password confirmation do not match."
      erb :"/users/sign-up", :layout => :layout, :locals => { :email => params[:email] }
    end
  end

  get '/users/sign-in' do
    erb :"users/sign-in", :layout => :layout
  end

  post '/users/sign-in' do    
    if $db.check_signin_details(params[:email], params[:password])
      session[:current_user_email] = params[:email]
      flash[:info] = "Successfully signed in."
      redirect to("/")
    else
      flash.now[:fatal] = "Email and/or password not valid. Please try again."
      erb :"users/sign-in", :layout => :layout
    end
  end

  post '/users/sign-out' do
    if session[:current_user_email]
      session[:current_user_email] = params[:email]
      flash[:info] = "Successfully signed out."
      redirect to("/")
    else
      flash.now[:info] = "Not Signed In"
    end
  end
end