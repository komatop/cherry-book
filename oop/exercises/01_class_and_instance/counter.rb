class Counter
  attr_reader :count
  def initialize
    @count = 0
  end

  def click
    @count = @count + 1
  end
end
