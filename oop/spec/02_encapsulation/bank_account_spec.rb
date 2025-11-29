require_relative '../../exercises/02_encapsulation/bank_account'

RSpec.describe BankAccount do
  describe '#balance' do
    it '初期残高を指定できる' do
      account = BankAccount.new(1000)
      expect(account.balance).to eq 1000
    end

    it '初期残高を省略すると0になる' do
      account = BankAccount.new
      expect(account.balance).to eq 0
    end
  end

  describe '#deposit' do
    it '入金すると残高が増える' do
      account = BankAccount.new(1000)
      account.deposit(500)
      expect(account.balance).to eq 1500
    end

    it '複数回入金できる' do
      account = BankAccount.new
      account.deposit(100)
      account.deposit(200)
      account.deposit(300)
      expect(account.balance).to eq 600
    end
  end

  describe '#withdraw' do
    it '出金すると残高が減る' do
      account = BankAccount.new(1000)
      account.withdraw(300)
      expect(account.balance).to eq 700
    end

    it '出金に成功するとtrueを返す' do
      account = BankAccount.new(1000)
      result = account.withdraw(300)
      expect(result).to be true
    end

    it '残高が足りないと出金できない' do
      account = BankAccount.new(500)
      result = account.withdraw(1000)
      expect(result).to be false
      expect(account.balance).to eq 500
    end

    it '残高ちょうどの出金はできる' do
      account = BankAccount.new(500)
      result = account.withdraw(500)
      expect(result).to be true
      expect(account.balance).to eq 0
    end
  end

  describe 'カプセル化' do
    it '外部からbalanceを直接変更できない' do
      account = BankAccount.new(1000)
      expect(account).not_to respond_to(:balance=)
    end
  end
end
