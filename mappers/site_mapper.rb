require_relative 'user_mapper'
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

  def already_taken?(site)
    @db.connection.collection('sites').find("url" => site.url).to_a.count > 0
  end

  def find_by_code(code)
    if hash = @db.connection.collection('sites').find_one("code" => code)
      user = UserMapper.new(@db).find_by_id(hash["user_id"])
      Site.new(user, hash["url"], hash["code"], hash["_id"])
    end
  end

  def create_unique_code(site)
    code = site.generate_code
    while find_by_code(code) do
      code = site.generate_code
    end
    code
  end
end