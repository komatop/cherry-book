class Car
  attr_reader :engine

  def initialize(engine)
    @engine = engine
  end

  def start
    @engine.start
  end
end
