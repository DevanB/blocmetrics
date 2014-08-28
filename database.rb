require 'mongo'

class Database
  def initialize
    @db = Mongo::MongoClient.new("localhost", 27017).db('development')
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

  def email_already_signed_up?(email)
    @db.collection('users').find("email" => email).to_a.count > 0
  end

  def insert_user(email, password)
    @db.collection('users').insert({"email" => email, "password" => password})
  end

  def valid_signin_details?(email, password)
    record = UserMapper.new(self).find_by_email(email)
    record && record.password == password
  end

  def create_site(user_id, url, code)
    @db.collection('sites').insert( { "user_id" => user_id, "url" => url, "code" => code } )
  end

  def get_sites_for_user(user)
    @db.collection('sites').find("user_id" => user.id).to_a
  end

  def code_unique?(code)
    @db.collection('sites').find("code" => code).to_a.count == 0
  end

  def site_already_taken?(url)
    @db.collection('sites').find("url" => url).to_a.count > 0
  end
end