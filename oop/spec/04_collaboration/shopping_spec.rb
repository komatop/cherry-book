require_relative '../../exercises/04_collaboration/product'
require_relative '../../exercises/04_collaboration/cart'

RSpec.describe 'Shopping System' do
  describe Product do
    it 'has a name and price' do
      product = Product.new(name: 'Apple', price: 150)
      expect(product.name).to eq 'Apple'
      expect(product.price).to eq 150
    end
  end

  describe Cart do
    let(:cart) { Cart.new }
    let(:apple) { Product.new(name: 'Apple', price: 150) }
    let(:banana) { Product.new(name: 'Banana', price: 100) }
    let(:orange) { Product.new(name: 'Orange', price: 200) }

    describe '#add' do
      it 'adds a product to the cart' do
        cart.add(apple)
        expect(cart.items.size).to eq 1
      end

      it 'can add multiple products' do
        cart.add(apple)
        cart.add(banana)
        cart.add(orange)
        expect(cart.items.size).to eq 3
      end
    end

    describe '#items' do
      it 'returns empty array when cart is empty' do
        expect(cart.items).to eq []
      end

      it 'returns all added products' do
        cart.add(apple)
        cart.add(banana)
        expect(cart.items).to include(apple, banana)
      end
    end

    describe '#total_price' do
      it 'returns 0 when cart is empty' do
        expect(cart.total_price).to eq 0
      end

      it 'returns the sum of all product prices' do
        cart.add(apple)
        cart.add(banana)
        cart.add(orange)
        expect(cart.total_price).to eq 450
      end

      it 'works with a single product' do
        cart.add(apple)
        expect(cart.total_price).to eq 150
      end
    end
  end
end
