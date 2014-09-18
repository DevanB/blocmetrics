require_relative '../../models/user'
require_relative '../../models/site'
require_relative '../../models/event'
require_relative '../../mappers/event_mapper'
require 'spec_helper'

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

    expect(found).to have_content(event)
  end

  xit "should persist to database without one property" do
  end

  xit "should persist to database without both properties" do
  end

  xit "should not persist to database if no unique ID is present" do
  end

  xit "should not persist to database if no event name is present" do
  end

  it "should find events when given a valid code" do
    mapper.persist(event)
    events = mapper.find_events_for_code(site.code)

    expect(events).to have_content(event)
  end
end