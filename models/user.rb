class User
  attr_reader :email, :password, :id
  
  def initialize(email, password, id = nil)
    @email, @password, @id = email, password, id
  end

  def is_valid_email?(email)
    /\b[a-zA-Z0-9._%+-]+@(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}\b/ =~ email
  end

  def is_valid_password?(password)
    /^\S+$/ =~ password
  end
end