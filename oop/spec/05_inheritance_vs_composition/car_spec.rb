require_relative '../../exercises/05_inheritance_vs_composition/gasoline_engine'
require_relative '../../exercises/05_inheritance_vs_composition/electric_engine'
require_relative '../../exercises/05_inheritance_vs_composition/car'

RSpec.describe 'Car and Engine' do
  describe GasolineEngine do
    it 'starts with a gasoline sound' do
      engine = GasolineEngine.new
      expect(engine.start).to eq 'Gasoline engine starting... Vroom!'
    end
  end

  describe ElectricEngine do
    it 'starts with an electric sound' do
      engine = ElectricEngine.new
      expect(engine.start).to eq 'Electric engine starting... Whirr!'
    end
  end

  describe Car do
    describe '#start' do
      it 'starts a car with gasoline engine' do
        car = Car.new(GasolineEngine.new)
        expect(car.start).to eq 'Gasoline engine starting... Vroom!'
      end

      it 'starts a car with electric engine' do
        car = Car.new(ElectricEngine.new)
        expect(car.start).to eq 'Electric engine starting... Whirr!'
      end
    end

    describe 'composition' do
      it 'Car does not inherit from any engine class' do
        expect(Car.superclass).to eq Object
      end

      it 'different cars can have different engines' do
        car1 = Car.new(GasolineEngine.new)
        car2 = Car.new(ElectricEngine.new)

        expect(car1.start).not_to eq car2.start
      end
    end
  end
end
