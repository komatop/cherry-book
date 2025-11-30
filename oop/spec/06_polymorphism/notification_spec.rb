require_relative '../../exercises/06_polymorphism/email_notifier'
require_relative '../../exercises/06_polymorphism/slack_notifier'
require_relative '../../exercises/06_polymorphism/sms_notifier'
require_relative '../../exercises/06_polymorphism/notification_service'

RSpec.describe 'Notification System' do
  describe EmailNotifier do
    it 'sends an email notification' do
      notifier = EmailNotifier.new
      expect(notifier.send('Hello!')).to eq 'Sending Email: Hello!'
    end
  end

  describe SlackNotifier do
    it 'sends a slack notification' do
      notifier = SlackNotifier.new
      expect(notifier.send('Hello!')).to eq 'Sending Slack: Hello!'
    end
  end

  describe SmsNotifier do
    it 'sends an SMS notification' do
      notifier = SmsNotifier.new
      expect(notifier.send('Hello!')).to eq 'Sending SMS: Hello!'
    end
  end

  describe NotificationService do
    it 'works with EmailNotifier' do
      service = NotificationService.new(EmailNotifier.new)
      expect(service.notify('Test')).to eq 'Sending Email: Test'
    end

    it 'works with SlackNotifier' do
      service = NotificationService.new(SlackNotifier.new)
      expect(service.notify('Test')).to eq 'Sending Slack: Test'
    end

    it 'works with SmsNotifier' do
      service = NotificationService.new(SmsNotifier.new)
      expect(service.notify('Test')).to eq 'Sending SMS: Test'
    end

    describe 'polymorphism' do
      it 'NotificationService does not check notifier type' do
        # Any object with a send method works
        custom_notifier = Object.new
        def custom_notifier.send(message)
          "Custom: #{message}"
        end

        service = NotificationService.new(custom_notifier)
        expect(service.notify('Test')).to eq 'Custom: Test'
      end
    end
  end
end
