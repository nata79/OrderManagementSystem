require 'spec_helper'

describe '/api/v1/orders/:id/line_items', :api do
  before { host! 'example.org' }  

  let(:token) { create :access_token }
  
  let(:order) { create :order }
  let(:line_items_count) { 10 }
  before { line_items_count.times { create :line_item, order: order } }

  describe '#index' do
    before { get api_v1_order_line_items_path(order), access_token: token.token }

    it { last_response.status.should eq 200 }

    it 'should return 10 lines' do
      lines = JSON.parse last_response.body
      lines.count.should eq 10
    end
  end

  describe '#show' do
    let(:line_item) { order.line_items.first }

    it 'returns a 401 without an access_token' do 
      get api_v1_order_line_item_path order, id: 20
      last_response.status.should eq 401
    end

    it { get api_v1_order_line_item_path(order, line_item), access_token: token.token
         last_response.status.should eq 200 }

    it 'returns the id, product, quantity, net_price and location' do      
      get api_v1_order_line_item_path(order, line_item), access_token: token.token
      
      json_line_item = JSON.parse last_response.body
      
      json_line_item['id'].should eq line_item.id
      json_line_item['quantity'].should eq line_item.quantity
      json_line_item['net_price_pennies'].should eq line_item.net_price_pennies
      json_line_item['net_price_currency'].should eq line_item.net_price_currency

      json_line_item['product']['id'].should eq line_item.product_id
      json_line_item['product']['name'].should eq line_item.product.name
      json_line_item['product']['location'].should eq api_v1_product_url(line_item.product)
      
      json_line_item['location'].should eq api_v1_order_line_item_url(order, line_item)
    end

    it 'returns a 404 if the line item does not exist' do 
      get api_v1_order_line_item_path order, id: 20, access_token: token.token
      last_response.status.should eq 404 
    end
  end

  describe '#create' do
    it 'returns a 401 without access_token' do
      post api_v1_order_line_items_path order_id: order.id, line_item: { product_id: create(:product).id }
      last_response.status.should eq 401
    end

    it 'returns a 400 if no quantity is passed' do
      post api_v1_order_line_items_path order_id: order.id, line_item: { product_id: create(:product).id }, access_token: token.token
      last_response.status.should eq 400
    end

    it 'returns a 400 if quantity is 0' do
      post api_v1_order_line_items_path order_id: order.id, line_item: { product_id: create(:product).id, quantity: 0 }, access_token: token.token
      last_response.status.should eq 400
    end

    it 'returns a 400 if no product is passed' do
      post api_v1_order_line_items_path order_id: order.id, line_item: { quantity: 0 }, access_token: token.token
      last_response.status.should eq 400
    end

    context 'order status' do
      it 'returns a 200 if order is draft' do
        post api_v1_order_line_items_path order_id: order.id, line_item: { product_id: create(:product).id, quantity: 10 }, access_token: token.token
        last_response.status.should eq 200
      end

      it 'returns a 400 if order is placed' do
        order.place
        post api_v1_order_line_items_path order_id: order.id, line_item: { product_id: create(:product).id, quantity: 10 }, access_token: token.token
        last_response.status.should eq 400
      end

      it 'returns a 400 if order is payed' do
        order.place; order.pay
        post api_v1_order_line_items_path order_id: order.id, line_item: { product_id: create(:product).id, quantity: 10 }, access_token: token.token
        last_response.status.should eq 400
      end

      it 'returns a 400 if order is canceled' do
        order.cancel
        post api_v1_order_line_items_path order_id: order.id, line_item: { product_id: create(:product).id, quantity: 10 }, access_token: token.token
        last_response.status.should eq 400
      end
    end
  end

  describe '#update' do
    let(:line_item) { order.line_items.first }

    it 'returns a 401 without access_token' do
      put api_v1_order_line_item_path order_id: order.id, id: line_item.id, line_item: { product_id: create(:product).id, quantity: 10 }
      last_response.status.should eq 401
    end

    it 'returns a 400 if quantity is 0' do
      put api_v1_order_line_item_path order_id: order.id, id: line_item.id, line_item: { product_id: create(:product).id, quantity: 0 }, access_token: token.token
      last_response.status.should eq 400
    end
    
    context 'order status' do
      it 'returns a 200 if order is draft' do
        put api_v1_order_line_item_path order_id: order.id, id: line_item.id, line_item: { product_id: create(:product).id, quantity: 15 }, access_token: token.token
        last_response.status.should eq 200
      end

      it 'returns a 400 if order is placed' do
        order.place
        put api_v1_order_line_item_path order_id: order.id, id: line_item.id, line_item: { product_id: create(:product).id, quantity: 15 }, access_token: token.token
        last_response.status.should eq 400
      end

      it 'returns a 400 if order is payed' do
        order.place; order.pay
        put api_v1_order_line_item_path order_id: order.id, id: line_item.id, line_item: { product_id: create(:product).id, quantity: 15 }, access_token: token.token
        last_response.status.should eq 400
      end

      it 'returns a 400 if order is canceled' do
        order.cancel
        put api_v1_order_line_item_path order_id: order.id, id: line_item.id, line_item: { product_id: create(:product).id, quantity: 15 }, access_token: token.token
        last_response.status.should eq 400
      end
    end
  end

  describe '#destroy' do
    let(:line_item) { order.line_items.first }

    it 'returns a 401 without an access_token' do
      delete api_v1_order_line_item_path order_id: order.id, id: line_item.id
      last_response.status.should eq 401
    end

    it 'returns a 200 if order is draft' do
      delete api_v1_order_line_item_path order_id: order.id, id: line_item.id, access_token: token.token
      last_response.status.should eq 200
    end    

    it 'returns a 400 if order is placed' do
      order.place
      delete api_v1_order_line_item_path order_id: order.id, id: line_item.id, access_token: token.token
      last_response.status.should eq 400
    end

    it 'returns a 400 if order is payed' do
      order.place; order.pay
      delete api_v1_order_line_item_path order_id: order.id, id: line_item.id, access_token: token.token
      last_response.status.should eq 400
    end

    it 'returns a 400 if order is canceled' do
      order.cancel
      delete api_v1_order_line_item_path order_id: order.id, id: line_item.id, access_token: token.token
      last_response.status.should eq 400
    end
  end
end