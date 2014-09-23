require 'mongo'

class Database
  def initialize
    if ENV['MONGOHQ_URL']
      uri = URI.parse(ENV['MONGOHQ_URL'])
      db_name = uri.path.gsub(/^\//, '')
      @db = Mongo::Connection.new(uri.host, uri.port).db(db_name)
      @db.authenticate(uri.user, uri.password) unless (uri.user.nil? || uri.password.nil?)
    else
      @db = Mongo::MongoClient.new("localhost", 27017).db(ENV["DATABASE_NAME"] || 'development')
    end
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