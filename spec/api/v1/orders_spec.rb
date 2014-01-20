require 'spec_helper'

describe '/api/v1/orders', :api do
  before { host! 'example.org' }

  let(:token) { create :access_token }
  
  let(:order_count) { 10 }
  before { order_count.times { create :order } }

  describe '#index' do    
    before { get api_v1_orders_path, access_token: token.token }

    it 'returns a 401 without an access_token' do 
      get api_v1_orders_path
      last_response.status.should eq 401
    end

    it { last_response.status.should eq 200 }

    it 'should return 10 orders' do
      orders = JSON.parse last_response.body
      orders.count.should eq 10
    end
  end

  describe '#show' do
    let(:order) { Order.first }

    it 'returns a 401 without an access_token' do 
      get api_v1_order_path id: 20
      last_response.status.should eq 401
    end

    it { get api_v1_order_path(order), access_token: token.token
         last_response.status.should eq 200 }

    it 'returns the id, order_date, vat, net_total, gross_total, line_items and location' do      
      add_line_items order

      get api_v1_order_path(order), access_token: token.token
      
      json_order = JSON.parse last_response.body
      
      json_order['id'].should eq order.id
      Date.parse(json_order['order_date']).should eq order.order_date
      json_order['vat'].should eq order.vat
      json_order['status'].should eq order.status
      
      net_total = Money.new json_order['net_total_pennies'], json_order['net_total_currency']
      net_total.should eq order.net_total
      
      gross_total = Money.new json_order['gross_total_pennies'], json_order['gross_total_currency']
      gross_total.should eq order.gross_total

      json_order['line_items'].count.should be 5
      
      json_order['location'].should eq api_v1_order_url(order)
    end

    it 'returns a 404 if the order does not exist' do 
      get api_v1_order_path id: 20, access_token: token.token
      last_response.status.should eq 404 
    end
  end

  describe '#create' do
    it 'returns a 401 without an access_token' do 
      post api_v1_orders_path order: { vat: 0.2, order_date: Date.today }
      last_response.status.should eq 401
    end

    it 'returns a 400 if there is no order date' do 
      post api_v1_orders_path order: { vat: 0.2 }, access_token: token.token
      last_response.status.should eq 400
    end

    it 'returns a 400 if there a past order date is passed' do 
      post api_v1_orders_path order: { order_date: Date.yesterday }, access_token: token.token
      last_response.status.should eq 400
    end

    it 'returns a 200 if no vat is passed' do 
      post api_v1_orders_path order: { order_date: Date.tomorrow }, access_token: token.token
      last_response.status.should eq 200
    end

    it 'returns a 200 if a vat and an order date are passed' do
      post api_v1_orders_path order: { vat: 0.2, order_date: Date.today }, access_token: token.token
      last_response.status.should eq 200
    end
  end

  describe '#update' do
    let(:order) { Order.first }

    it 'returns a 401 without an access_token' do
      put api_v1_order_path order: { order_date: Date.today, vat: 0.15 }, id: order.id
      last_response.status.should eq 401
    end

    it 'returns a 200 if the order is in draft state' do
      put api_v1_order_path order: { order_date: Date.today, vat: 0.15 }, id: order.id, access_token: token.token
      last_response.status.should eq 200
    end

    it 'returns a 400 if the order is in placed status' do 
      order.place
      put api_v1_order_path order: { order_date: Date.today, vat: 0.15 }, id: order.id, access_token: token.token
      last_response.status.should eq 400
    end

    it 'returns a 400 if the order is in payed status' do 
      order.place; order.pay
      put api_v1_order_path order: { order_date: Date.today, vat: 0.15 }, id: order.id, access_token: token.token
      last_response.status.should eq 400
    end

    it 'returns a 400 if the order is in canceled status' do 
      order.cancel
      put api_v1_order_path order: { order_date: Date.today, vat: 0.15 }, id: order.id, access_token: token.token
      last_response.status.should eq 400
    end
  end
end