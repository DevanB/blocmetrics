class UserMapper
  def initialize(db)
    @db = db
  end

  def find_by_email(email)
    if hash = @db.connection.collection('users').find_one("email" => email)
      User.new(hash["email"], hash["password"], hash["_id"])
    end
  end
end