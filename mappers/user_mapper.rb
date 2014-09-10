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
    user.validate
    id = @db.connection.collection('users').insert({"email" => user.email, "password" => user.password})
    user.id = id
  rescue Mongo::OperationFailure => e
    if e.message =~ /11000/
      raise ValidationError.new("Email address already registered.")
    end
  end

  def valid_signin_details?(email, password)
    record = self.find_by_email(email)
    record && record.password == password
  end
end