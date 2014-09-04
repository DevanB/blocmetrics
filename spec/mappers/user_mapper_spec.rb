require_relative '../../models/user'
require_relative '../../mappers/user_mapper'
require 'spec_helper'

describe UserMapper do

  describe "persist" do
    
    let(:db) {Database.new}
    let(:mapper) {UserMapper.new(db)}
    let(:user) {User.new("test@test.com", "testpassword")}

    it "should set id of site that it persisted" do
      mapper.persist(user)

      expect(user.id).to_not be(nil)
    end
  end
  
end