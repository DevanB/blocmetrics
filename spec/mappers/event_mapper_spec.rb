require 'spec_helper'
require_relative '../../models/user'
require_relative '../../models/site'
require_relative '../../models/event'
require_relative '../../mappers/event_mapper'
require_relative '../../mappers/site_mapper'
require_relative '../../database'
require_relative '../../app'


describe EventMapper do
  let(:db) {Database.new}
  let(:mapper) {EventMapper.new(db)}
  let(:user) {User.new("test@test.com", "testpassword", "testpassword")}
  let(:url) {"http://test.com"}
  let(:site) {Site.new(user, url)}
  let(:event) {Event.new(site.code, "event name", "1", "2")}

  it "should persist to database with multiple values" do
    SiteMapper.new($db).persist(site)
    mapper.persist(event)
    found = mapper.find_events_for_code(site.code)

    expect(found).to include(event)
  end

  xit "should persist to database without both properties" do
  end

  xit "should not persist to database if no unique code is present" do
  end

  xit "should not persist to database if no event name is present" do
  end
end