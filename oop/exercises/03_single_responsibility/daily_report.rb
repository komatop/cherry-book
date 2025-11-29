class DailyReport
  attr_accessor :date, :tasks

  def initialize(date:, tasks:)
    @date = date
    @tasks = tasks
  end
end

