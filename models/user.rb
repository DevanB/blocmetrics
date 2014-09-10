class User
  attr_accessor :email, :password, :password_confirmation, :id
  
  def initialize(email, password, password_confirmation, id = nil)
    @email, @password, @password_confirmation, @id = email, password, password_confirmation, id
  end

  def validate
    if !is_valid_email?
      raise ValidationError.new("Email address is not valid.")
    end
    if !is_valid_password?
      raise ValidationError.new("Password is not valid format.")
    end
    if !password_matches?
      raise ValidationError.new("Password and password confirmation do not match.")
    end
  end

  def is_valid_email?
    /\b[a-zA-Z0-9._%+-]+@(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}\b/ =~ email
  end

  def is_valid_password?
    /^\S+$/ =~ password
  end

  def password_matches?
    password == password_confirmation
  end
end