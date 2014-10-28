class Analytic
  attr_accessor :events

  def initialize(events)
    @events = events
  end

  def group_by_name
    colors = ["red", "green", "blue", "gray"]
    highlights = ["green", "red", "gray"]
    counted_events = events.group_by { |event| event.name }.map{ |name, events| { value: events.count, label: name } }
    counted_events.zip(colors, highlights).map do |counted_event, color, highlight|
      counted_event.merge({ color: color, hightlight: highlight })
    end
  end
end