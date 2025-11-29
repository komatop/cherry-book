require_relative '../../exercises/03_single_responsibility/daily_report'
require_relative '../../exercises/03_single_responsibility/text_formatter'
require_relative '../../exercises/03_single_responsibility/markdown_formatter'

RSpec.describe 'Daily Report System' do
  let(:report) do
    DailyReport.new(
      date: '2025-01-15',
      tasks: [
        'Implement user authentication',
        'Code review',
        'Team meeting'
      ]
    )
  end

  describe DailyReport do
    it 'returns the date' do
      expect(report.date).to eq '2025-01-15'
    end

    it 'returns the tasks' do
      expect(report.tasks).to eq [
        'Implement user authentication',
        'Code review',
        'Team meeting'
      ]
    end
  end

  describe TextFormatter do
    it 'formats as plain text' do
      formatter = TextFormatter.new
      result = formatter.format(report)

      expect(result).to include('=== Report: 2025-01-15 ===')
      expect(result).to include('- Implement user authentication')
      expect(result).to include('- Code review')
      expect(result).to include('- Team meeting')
    end
  end

  describe MarkdownFormatter do
    it 'formats as markdown' do
      formatter = MarkdownFormatter.new
      result = formatter.format(report)

      expect(result).to include('# Report: 2025-01-15')
      expect(result).to include('- Implement user authentication')
      expect(result).to include('- Code review')
      expect(result).to include('- Team meeting')
    end
  end

  describe 'Separation of concerns' do
    it 'DailyReport does not have format methods' do
      expect(report).not_to respond_to(:to_text)
      expect(report).not_to respond_to(:to_markdown)
      expect(report).not_to respond_to(:format)
    end
  end
end
