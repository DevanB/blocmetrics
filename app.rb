require "sinatra/base"
require 'mongo'
require 'json/ext'
require 'pry'
require 'pry-debugger'

class App < Sinatra::Base
  configure do
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
    pageCount = @hash["page_count"]
    pageCount
  end

  def increment_page_count
    pageCountId = @hash["_id"]
    @db.collection('pageCounts').update({"_id" => pageCountId}, {"$set" => {"page_count" => (get_page_count + 1)}})
  end

  def clear_page_count
    pageCountId = @hash["_id"]
    @db.collection('pageCounts').update({"_id" => pageCountId}, {"$set" => {"page_count" => 0}})
  end
end