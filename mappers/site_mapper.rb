class SiteMapper
  def initialize(db)
    @db = db
  end

  def create(user_id, url, code)
    @db.connection.collection('sites').insert( { "user_id" => user_id, "url" => url, "code" => code } )
  end

  def get_sites_for_user(user)
    @db.connection.collection('sites').find("user_id" => user.id).to_a
  end

  def code_unique?(code)
    @db.connection.collection('sites').find("code" => code).to_a.count == 0
  end

  def already_taken?(url)
    @db.connection.collection('sites').find("url" => url).to_a.count > 0
  end
end