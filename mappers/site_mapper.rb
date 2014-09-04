class SiteMapper
  def initialize(db)
    @db = db
  end

  def persist(site)
    code = create_unique_code(site)
    id = @db.connection.collection('sites').insert( { "user_id" => site.user.id, "url" => site.url, "code" => code } )
    site.code = code
    site.id = id
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

  def create_unique_code(site)
    code = site.generate_code
    until code_unique?(code) do
      code = site.generate_code
    end
    code
  end
end