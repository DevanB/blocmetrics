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
    @db.collection('pageCounts').update({}, {"$inc" => {"page_count" => 1}}, {upsert: true})
  end

  def check_email_for_signup(email)
    return true if @db.collection('users').find("email" => email).to_a.count > 0
  end

  def insert_user(email, password)
    @db.collection('users').insert({"email" => email, "password" => password})
  end

  def check_signin_details(email, password)
    record = @db.collection('users').find_one("email" => email)
    record["password"] == password
  end
end