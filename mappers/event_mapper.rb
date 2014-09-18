class EventMapper
  def initialize(db)
    @db = db
  end

  def persist(event)
    id = @db.connection.collection('events').insert({"code" => event.code, "name" => event.name, "property1" => event.property1, "property2" => event.property2})
    event.id = id
  end

  def find_events_for_code(code)
    events = []
    objects = @db.connection.collection('events').find("code" => code).to_a
    objects.each do |object|
      events << Event.new(object["code"], object["name"], object["property1"], object["property2"], object["_id"])
    end
    events
  end
end