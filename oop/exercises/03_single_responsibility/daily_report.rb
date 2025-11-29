class DailyReport
  attr_reader :date, :tasks

  def initialize(date:, tasks:)
    @date = date
    @tasks = tasks
  end
end

