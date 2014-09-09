class UserMapper
  def initialize(db)
    @db = db
    @db.connection.collection('users').ensure_index({"email" => 1}, { "unique" => true})
    end

  def find_by_email(email)
    if hash = @db.connection.collection('users').find_one("email" => email)
      User.new(hash["email"], hash["password"], hash["_id"])
    end
  end

  def persist(user)
    id = @db.connection.collection('users').insert({"email" => user.email, "password" => user.password})
    user.id = id
  end

  def valid_signin_details?(email, password)
    record = self.find_by_email(email)
    record && record.password == password
  end
end