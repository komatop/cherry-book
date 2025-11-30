class NotificationService
  attr_reader :notifier

  def initialize(notifier)
    @notifier = notifier
  end

  def notify(message)
    @notifier.send(message)
  end
end
