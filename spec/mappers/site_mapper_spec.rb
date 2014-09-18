require 'spec_helper'
require_relative '../../models/site'
require_relative '../../models/user'
require_relative '../../mappers/site_mapper'


describe SiteMapper do

  describe "persist" do
    
    let(:db) {Database.new}
    let(:mapper) {SiteMapper.new(db)}
    let(:user) {User.new("test@test.com", "testpassword", "testpassword")}
    let(:url) {"http://test.com"}
    let(:site) {Site.new(user, url)}

    it "should set code of site that it persisted" do
      mapper.persist(site)

      expect(site.code).to_not be(nil)
    end

    it "should set id of site that it persisted" do
      mapper.persist(site)

      expect(site.id).to_not be(nil)
    end
  end
  
end