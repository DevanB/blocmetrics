class Event
  attr_accessor :id, :code, :name, :property1, :property2, :created_at

  def initialize(code, name, property1 = nil, property2 = nil, id = nil)
    @code, @name, @property1, @property2, @id = code, name, property1, property2, id
    @created_at = Time.now
  end

  def ==(object)
    self.class == object.class &&
      self.code == object.code &&
      self.name == object.name &&
      self.property1 == object.property1 &&
      self.property2 == object.property2 &&
      self.id == object.id
  end
end