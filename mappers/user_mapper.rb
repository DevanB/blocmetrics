class UserMapper
  def initialize(db)
    @db = db
  end

  def find_by_email(email)
    if hash = @db.connection.collection('users').find_one("email" => email)
      User.new(hash["email"], hash["password"], hash["_id"])
    end
  end

  def email_already_signed_up?(email)
    @db.connection.collection('users').find("email" => email).to_a.count > 0
  end

  def insert(email, password)
    @db.connection.collection('users').insert({"email" => email, "password" => password})
  end
end