require 'spec_helper'

describe StatusTransition do
  let(:order) { create(:order) }

  it 'requires an event' do
    build(:status_transition, event: nil).should_not be_valid
  end

  it 'requires an order' do
    build(:status_transition, order: nil).should_not be_valid
  end

  it 'requires a reason if event is cancel' do
    build(:status_transition, event: 'cancel').should_not be_valid
  end

  it 'does not accept an event that isnt place, pay or cancel' do
    build(:status_transition, event: :invalid).should_not be_valid
  end

  it 'sets the from attribute to the current order status' do
    transition = order.transitions.create event: 'place'
    transition.from.should eq 'draft'
  end

  it 'sets the to attribute to the next order status' do
    transition = order.transitions.create event: 'place'
    transition.to.should eq 'placed'
  end

  it 'does not save if the order cannot process the event' do
    order.transitions.create(event: 'pay').should_not be_valid
  end

  it 'executes the transition in the order' do
    order.transitions.create event: 'place'
    order.reload
    order.status.should eq 'placed'
  end

  it 'does not execute the transition in the order if the transition is invalid' do
    order.transitions.create event: 'pay'
    order.reload
    order.status.should eq 'draft'
  end
end
