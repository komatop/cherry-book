require_relative '../../exercises/01_class_and_instance/counter'

RSpec.describe Counter do
  describe '#count' do
    it '初期値は0' do
      counter = Counter.new
      expect(counter.count).to eq 0
    end
  end

  describe '#click' do
    it '1回クリックすると1になる' do
      counter = Counter.new
      counter.click
      expect(counter.count).to eq 1
    end

    it '3回クリックすると3になる' do
      counter = Counter.new
      3.times { counter.click }
      expect(counter.count).to eq 3
    end
  end

  describe '複数のインスタンス' do
    it '各カウンターは独立している' do
      counter1 = Counter.new
      counter2 = Counter.new

      counter1.click
      counter1.click

      expect(counter1.count).to eq 2
      expect(counter2.count).to eq 0
    end
  end
end
