require 'spec_helper'
require_relative '../../models/event'
require_relative '../../models/analytic'

describe Analytic do
  it "should return valid data for ChartJS" do
    event1 = Event.new("123456", "event", "1", "2")
    EventMapper.new($db).persist(event1)
    event2 = Event.new("123456", "event name", "1", "2")
    EventMapper.new($db).persist(event2)
    event3 = Event.new("123456", "event again", "1", "2")
    EventMapper.new($db).persist(event3)

    events = EventMapper.new($db).find_events_for_code("123456")
    chartData = Analytic.new(events).group_by_name

    p chartData
  end
end