require 'spec_helper'
require_relative '../../models/event'

describe Event do
  it "should compare events by equality" do
    event1 = Event.new("123456", "event name", "1", "2", "1")
    event2 = Event.new("123456", "event name", "1", "2", "1")

    expect(event1).to eq(event2)
  end

  it "should add created_at datetime to new events" do
    event = Event.new("123456", "event name")

    expect(event.created_at).to_not be_nil
    expect(event.created_at.class).to eq(Time)
  end
end