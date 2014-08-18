require 'mongo' 

class Database
  def initialize
    @db = Mongo::MongoClient.new("localhost", 27017).db('development')
  end

  def hash
    @db.collection('pageCounts').find_one()
  end

  def get_page_count
    hash["page_count"]
  end

  def increment_page_count
    @db.collection('pageCounts').update({"_id" => hash["_id"]}, {"$inc" => {"page_count" => 1}})
  end

  def clear_page_count
    @db.collection('pageCounts').update({"_id" => hash["_id"]}, {"$set" => {"page_count" => 0}})
  end

  def insert_user(email, password)
    @db.collection('users').insert({"email" => email, "password" => password})
  end
end