require "sinatra/base"
require "sinatra/reloader"
require 'mongo'
require 'json/ext'
require 'pry'
require 'pry-debugger'

class App < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get "/"  do
    db = Database.new
    db.increment_page_count
    "Hello World #{db.get_page_count}"
  end

end

class Database
  def initialize
    @db = Mongo::MongoClient.new("localhost", 27017).db('development')
    @hash = @db.collection('pageCounts').find_one()
  end

  def get_page_count
    @hash["page_count"]
  end

  def increment_page_count
    @db.collection('pageCounts').update({"_id" => @hash["_id"]}, {"$inc" => {"page_count" => 1}})
  end

  def clear_page_count
    @db.collection('pageCounts').update({"_id" => @hash["_id"]}, {"$set" => {"page_count" => 0}})
  end
end