require 'spec_helper'

describe Order do
  it 'requires an order date' do
    build(:order, order_date: nil).should_not be_valid
  end

  it 'cant be created with a past order date' do
    build(:order, order_date: Date.yesterday).should_not be_valid
  end

  it 'can be updated after the order date' do
    order = create(:order)
    
    Timecop.freeze(Date.tomorrow) do
      order.update_attributes(vat: 0.15)
      order.should be_valid
    end
  end

  it 'sets a defalut value for vat' do
    create(:order).vat.should eq VAT
  end

  it 'cant be destroyed' do
    order = create(:order)
    lambda{ order.destroy }.should raise_error
  end

  it 'should default to the draft status' do
    build(:order).status.should eq 'draft'
  end

  describe 'draft status' do
    let(:order) { build(:order) }

    it 'can be placed' do
      order.can_place?.should be_true
    end

    it 'can be canceled' do
      order.can_cancel?.should be_true
    end

    it 'cannot be payed' do
      order.can_pay?.should be_false
    end

    it 'can be updated' do
      order.update_attributes vat: 0.15, order_date: Date.today
      order.should be_valid
    end
  end

  describe 'placed status' do
    let(:order) { create(:order) }
    before { order.place }

    it 'cannot be placed' do      
      order.can_place?.should be_false
    end

    it 'can be canceled' do
      order.can_cancel?.should be_true
    end

    it 'can be payed' do
      order.can_pay?.should be_true
    end

    it 'cannot be updated' do
      order.update_attributes vat: 0.15, order_date: Date.today
      order.should_not be_valid
    end
  end

  describe 'payed status' do
    let(:order) { create(:order) }
    before { order.place; order.pay }

    it 'cannot be placed' do      
      order.can_place?.should be_false
    end

    it 'cannot be canceled' do
      order.can_cancel?.should be_false
    end

    it 'cannot be payed' do
      order.can_pay?.should be_false
    end

    it 'cannot be updated' do
      order.update_attributes vat: 0.15, order_date: Date.today
      order.should_not be_valid
    end
  end

  describe 'locked?' do
    let(:order) { create(:order) }

    it 'returns false if status is draft' do      
      order.locked?.should be_false
    end

    it 'returns true if status is placed' do      
      order.place
      order.locked?.should be_true
    end

    it 'returns true if status is payed' do      
      order.place; order.pay
      order.locked?.should be_true
    end
  end

  describe 'status_after_event' do
    it 'returns placed for place' do
      create(:order).status_after_event(:place).should eq 'placed'
    end

    it 'returns payed for pay' do
      order = create(:order)
      order.place
      order.status_after_event(:pay).should eq 'payed'
    end

    it 'returns canceled for cancel' do
      create(:order).status_after_event(:cancel).should eq 'canceled'
    end
  end

  describe 'net_total' do
    let(:order) { create :order }    

    it 'returns the sum of the net_prices of the line_items' do
      5.times do
        product = create :product, net_price: Money.new(100, :gbp)
        create :line_item, order: order, product: product
      end

      order.net_total.should eq Money.new(500, :gbp)
    end

    it 'returns 0 if ther is no line item' do
      order.net_total.should eq Money.new(0)
    end
  end

  describe 'gross_total' do
    let(:order) { create :order }    

    it 'returns the sum of the net_prices of the line_items' do
      5.times do
        product = create :product, net_price: Money.new(100, :gbp)
        create :line_item, order: order, product: product
      end

      order.gross_total.should eq Money.new(600, :gbp)
    end

    it 'returns 0 if ther is no line item' do
      order.gross_total.should eq Money.new(0)
    end
  end
end