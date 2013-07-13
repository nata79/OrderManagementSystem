require 'spec_helper'

describe LineItem do
  include MoneyRails::TestHelpers

  it 'requires a product' do
    build(:line_item, product: nil).should_not be_valid
  end

  it 'requires an order' do
    build(:line_item, order: nil).should_not be_valid
  end

  it 'requires a quantity' do
    build(:line_item, quantity: nil).should_not be_valid
  end

  it 'requires a quantity greater than 0' do
    build(:line_item, quantity: 0).should_not be_valid
  end

  it 'has a net_price attribute with the type Money' do
    build(:line_item).should monetize(:net_price_pennies).as(:net_price)
  end

  it 'is created with the net price from its product' do
    line_item = create :line_item
    line_item.net_price.should eq line_item.product.net_price
  end

  it 'updates the net price if the product changes' do
    line_item = create :line_item
    product2 = create :product, net_price: Money.new(50, :gbp)
    line_item.update_attributes product: product2
    line_item.net_price.should eq Money.new(50, :gbp)
  end

  it 'doesnt change the net price even if the product net price is updated' do
    product = create :product, net_price: Money.new(50, :gbp)
    line_item = create :line_item, product: product

    product.update_attributes net_price: Money.new(200)
    line_item.update_attributes quantity: 2

    line_item.net_price.should eq Money.new(50, :gbp)
  end
end
