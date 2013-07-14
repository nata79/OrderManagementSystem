require 'spec_helper'

describe Product do
  include MoneyRails::TestHelpers

  it 'requires a name' do
    build(:product, name: nil).should_not be_valid
  end

  it 'has a uniq name' do
    create(:product, name: 'Product Name')
    build(:product, name: 'Product Name').should_not be_valid
  end

  it 'has a net_price attribute with the type Money' do
    build(:product).should monetize(:net_price_pennies).as(:net_price)
  end

  it 'requires a net price higher than 0' do
    build(:product, net_price: Money.new(0, :gbp)).should_not be_valid
  end
end
