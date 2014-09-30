class EventMapper
  def initialize(db)
    @db = db
  end

  def persist(event)
    id = @db.connection.collection('events').insert({"code" => event.code, "name" => event.name, "property1" => event.property1, "property2" => event.property2, "created_at" => event.created_at})
    event.id = id
  end

  def find_events_for_code(code)
    to_event_objects(@db.connection.collection('events').find("code" => code))
  end

  def find_events_within_dates(date1, date2)
    to_event_objects( @db.connection.collection('events').find("created_at" => {'$gte' => date1, '$lte' => date2}).sort('created_at' => 1) )
  end

  private

  def to_event_objects(results)
    results.map do |result|
      Event.new(result["code"], result["name"], result["property1"], result["property2"], result["_id"])
    end
  end
end