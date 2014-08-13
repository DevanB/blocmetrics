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
  end

  def get_page_count
    hash = @db.collection('pageCounts').find_one()
    pageCount = hash["page_count"]
    pageCount
  end

  def increment_page_count
    hash = @db.collection('pageCounts').find_one()
    pageCountId = hash["_id"]
    @db.collection('pageCounts').update({"_id" => pageCountId}, {"$set" => {"page_count" => (get_page_count + 1)}})
  end

  def clear_page_count
    hash = @db.collection('pageCounts').find_one()
    pageCountId = hash["_id"]
    @db.collection('pageCounts').update({"_id" => pageCountId}, {"$set" => {"page_count" => 0}})
  end
end