class User
  attr_accessor :email, :password, :id
  
  def initialize(email, password, id = nil)
    @email, @password, @id = email, password, id
  end
end