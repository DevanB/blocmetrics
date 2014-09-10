require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/flash'
require 'haml'

require_relative 'database'
require_relative 'models/user'
require_relative 'models/site'
require_relative 'models/validation_error'
require_relative 'mappers/user_mapper'
require_relative 'mappers/site_mapper'

$db = Database.new

class App < Sinatra::Base
  enable :sessions
  register Sinatra::Flash

  configure :development do
    register Sinatra::Reloader
    also_reload 'database.rb'
    also_reload 'mappers/user_mapper.rb'
    also_reload 'mappers/site_mapper.rb'
    also_reload 'models/user.rb'
    also_reload 'models/site.rb'
    also_reload 'models/validation_error.rb'
  end

  before '/site/new' do
    unless current_user
      flash[:fatal] = "Not authorized. Please login first."
      redirect to("/")
    end
  end
  
  get '/'  do
    $db.increment_page_count
    @page_count = $db.get_page_count
    if current_user
      @sites = SiteMapper.new($db).get_sites_for_user(current_user)
    end
    haml :root, :layout => :layout
  end

  get '/users/sign-up' do
    haml :"users/sign-up", :layout => :layout, :locals => { :email => "" }
  end

  post '/users/sign-up' do
    begin
      user = User.new(params[:email], params[:password], params[:passwordConfirmation])
      UserMapper.new($db).persist(user)
      flash[:info] = "Successfully signed up!"
      redirect to("/users/sign-in")
    rescue ValidationError => e
      flash.now[:fatal] = e.message
      return haml :"/users/sign-up", :layout => :layout, :locals => { :email => params[:email] }
    end
  end

  get '/users/sign-in' do
    haml :"users/sign-in", :layout => :layout
  end

  post '/users/sign-in' do  
    if UserMapper.new($db).valid_signin_details?(params[:email], params[:password])
      session[:current_user_email] = params[:email]
      flash[:info] = "Successfully signed in."
      redirect to("/")
    else
      flash.now[:error] = "Email and/or password not valid. Please try again."
      haml :"users/sign-in", :layout => :layout
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
    haml :"site/new", :layout => :layout
  end

  post '/site/new' do
    site = Site.new(current_user, params[:url])

    begin
      site.validate 
    rescue ValidationError => e
      flash[:fatal] = e.message
      redirect to("/site/new")
      return
    end

    if SiteMapper.new($db).persist(site)
      flash[:info] = "Successfully added site."
      redirect to("/")
    else
      flash.now[:fatal] = "Site creation failed. Please try again."
      haml :"/site/new", :layout => :layout
    end
  end

  protected

  def current_user
    UserMapper.new($db).find_by_email(session[:current_user_email])
  end
end