require 'mongo'

class Database
  def initialize
    @db = Mongo::MongoClient.new("localhost", 27017).db(ENV["DATABASE_NAME"] || 'development')
  end

  def connection
    @db
  end

  def hash
    @db.collection('pageCounts').find_one()
  end

  def get_page_count
    hash["page_count"]
  end

  def increment_page_count
    @db.collection('pageCounts').update({}, {"$inc" => {"page_count" => 1}}, {upsert: true})
  end
end