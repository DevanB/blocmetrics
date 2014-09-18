require 'spec_helper'
require_relative '../../models/user'
require_relative '../../mappers/user_mapper'


describe UserMapper do

  describe "persist" do
    
    let(:db) {Database.new}
    let(:mapper) {UserMapper.new(db)}
    let(:user) {User.new("test@test.com", "testpassword", "testpassword")}

    before do
      MongoCleaner.clean
    end

    it "should set id of site that it persisted" do
      mapper.persist(user)

      expect(user.id).to_not be(nil)
    end

    it "should be findable by id and email" do
      mapper.persist(user)
      found_user = mapper.find_by_email(user.email)
      expect_users_to_eq(found_user, user)

      found_user = mapper.find_by_id(user.id)
      expect_users_to_eq(found_user, user)
    end
  end

  def expect_users_to_eq(user1, user2)
    attrs = %w(id email password password_confirmation)
    attrs.each do |attr|
      expect(user1.send(attr)).to eq(user2.send(attr))
    end
  end

end