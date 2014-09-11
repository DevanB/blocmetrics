require 'securerandom'

class Site
  attr_accessor :user, :url, :code, :id

  def initialize(user, url, code = nil, id = nil)
    @user, @url, @code, @id = user, url, code, id
  end

  def generate_code
    SecureRandom.hex(18)
  end

  def validate
    if !is_valid_url?
      raise ValidationError.new("URL is not a valid URL.")
    end
  end

  private

  def is_valid_url?
    /^(https?\:\/\/)?([a-zA-Z0-9\-\.]*)\.?([a-zA-Z0-9\-\.]*)\.([a-zA-Z]{2,})$/ =~ url
  end
end