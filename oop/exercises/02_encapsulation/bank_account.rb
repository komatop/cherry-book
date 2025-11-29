class BankAccount
  attr_reader :balance
  attr_writer :deposit, :withdraw

  def initialize(balance = 0)
    @balance = balance
  end

  def deposit(amount)
    @balance = @balance + amount
  end

  def withdraw(amount)
    return false if @balance < amount
    @balance = @balance - amount  
    true
  end
end
