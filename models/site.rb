class Site

  def initialize(user_id, url, code, id = nil)
    @user_id, @url, @code, @id = user_id, url, code, id
  end

  def is_valid_url?(url)
    /^(https?\:\/\/)?([a-zA-Z0-9\-\.]*)\.?([a-zA-Z0-9\-\.]*)\.([a-zA-Z]{2,})$/ =~ url
  end

  def create_unique_code
    code = SecureRandom.hex(18)
    until $db.code_unique?(code) do
      code = SecureRandom.hex(18)
    end
    code
  end
end