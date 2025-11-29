class Cart
  attr_reader :items 

  def initialize
    @items = []
  end

  def add(product)
    @items << product
  end

  def total_price
    @items.map{|item| item.price}.sum
  end
end
