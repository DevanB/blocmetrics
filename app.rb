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
    also_reload 'database'
  end

  get '/'  do
    $db.increment_page_count
    @page_count = $db.get_page_count
    if current_user
      @sites = $db.get_sites_for_user(current_user)
    end
    erb :root, :layout => :layout
  end

  get '/users/sign-up' do
    erb :"users/sign-up", :layout => :layout, :locals => { :email => "" }
  end

  post '/users/sign-up' do
    if $db.email_already_signed_up?(params[:email])
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
    if $db.valid_signin_details?(params[:email], params[:password])
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

  get '/site/new' do
    erb :"site/new", :layout => :layout
  end

  post '/site/new' do
    if $db.create_site(current_user["_id"], params[:url], create_unique_code)
      flash[:info] = "Successfully added site."
      redirect to("/")
    else
      flash.now[:fatal] = "Site creation failed. Please try again."
      erb :"/site/new", :layout => :layout
    end
  end

  protected

  def current_user
    $db.find_user_by_email(session[:current_user_email])
  end

  def create_unique_code
    code = SecureRandom.hex(18)
    unless $db.code_unique?(code)
      code = SecureRandom.hex(18)
    end
    code
  end

end