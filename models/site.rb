require 'securerandom'

class Site
  attr_accessor :user, :url, :code, :id

  def initialize(user, url, id = nil)
    @user, @url, @code, @id = user, url, nil, id
  end

  def generate_code
    SecureRandom.hex(18)
  end
end