require_relative '../../exercises/03_single_responsibility/daily_report'
require_relative '../../exercises/03_single_responsibility/text_formatter'
require_relative '../../exercises/03_single_responsibility/markdown_formatter'

RSpec.describe 'Daily Report System' do
  let(:report) do
    DailyReport.new(
      date: '2025-01-15',
      tasks: [
        'ユーザー認証機能の実装',
        'コードレビュー対応',
        'チームミーティング参加'
      ]
    )
  end

  describe DailyReport do
    it '日付を取得できる' do
      expect(report.date).to eq '2025-01-15'
    end

    it '作業内容を取得できる' do
      expect(report.tasks).to eq [
        'ユーザー認証機能の実装',
        'コードレビュー対応',
        'チームミーティング参加'
      ]
    end
  end

  describe TextFormatter do
    it 'プレーンテキスト形式で出力できる' do
      formatter = TextFormatter.new
      result = formatter.format(report)

      expect(result).to include('=== 日報: 2025-01-15 ===')
      expect(result).to include('- ユーザー認証機能の実装')
      expect(result).to include('- コードレビュー対応')
      expect(result).to include('- チームミーティング参加')
    end
  end

  describe MarkdownFormatter do
    it 'マークダウン形式で出力できる' do
      formatter = MarkdownFormatter.new
      result = formatter.format(report)

      expect(result).to include('# 日報: 2025-01-15')
      expect(result).to include('- ユーザー認証機能の実装')
      expect(result).to include('- コードレビュー対応')
      expect(result).to include('- チームミーティング参加')
    end
  end

  describe '責務の分離' do
    it 'DailyReportはフォーマットメソッドを持たない' do
      expect(report).not_to respond_to(:to_text)
      expect(report).not_to respond_to(:to_markdown)
      expect(report).not_to respond_to(:format)
    end
  end
end
