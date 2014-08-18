require "sinatra/base"
require "sinatra/reloader"
require_relative 'database'

$db = Database.new

class App < Sinatra::Base
  enable :sessions

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
    if params[:password] == params[:passwordConfirmation]
      $db.insert_user(params[:email], params[:password])
    else
      #TODO - Redirect to Sign Up form with flash passwords do not match.
    end
  end
  
end