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
  let(:event2) {Event.new(site.code, "event name 2", "1", "2")}
  let(:event3) {Event.new(site.code, "event name 3", "1", "2")}
  let(:event4) {Event.new(site.code, "event name 4", "1", "2")}

  it "should persist to database with multiple values" do
    SiteMapper.new($db).persist(site)
    mapper.persist(event)
    found = mapper.find_events_for_code(site.code)

    expect(found).to include(event)
  end

  it "should find events between two dates" do
    SiteMapper.new($db).persist(site)

    Timecop.freeze(Time.new(2014,9,27,9,7)) do
      mapper.persist(event)
    end
    Timecop.freeze(Time.new(2014,9,28,9,7)) do
      mapper.persist(event2)
    end
    Timecop.freeze(Time.new(2014,9,30,9,7)) do
      mapper.persist(event3)
    end
    Timecop.freeze(Time.new(2014,9,31,9,7)) do
      mapper.persist(event4)
    end

    found_events = mapper.find_events_within_dates(Time.new(2014,9,28,9,7), Time.new(2014,9,30,9,7))
    expect(found_events).to eq([event2, event3])
  end
end