require 'spec_helper'

describe '/api/v1/orders/:id/status_transitions', :api do
  before { host! 'example.org' }  

  let(:token) { create :access_token }
  
  let(:order) { create :order }  

  describe '#index' do
    before do 
      order.transitions.create! event: 'place'
      order.transitions.create! event: 'pay'
    end

    before { get api_v1_order_status_transitions_path(order), access_token: token.token }

    it 'returns a 401 without an access_token' do
      get api_v1_order_status_transitions_path(order)
      last_response.status.should eq 401
    end

    it { last_response.status.should eq 200 }

    it 'should return 2 transitions' do
      transitions = JSON.parse last_response.body
      transitions.count.should eq 2
    end
  end

  describe '#create' do
    it 'returns a 401 without an access_token' do
      post api_v1_order_status_transitions_path order_id: order.id, status_transition: { event: 'place' }
      last_response.status.should eq 401
    end

    it 'returns a 400 if cancel with no reason' do
      post api_v1_order_status_transitions_path order_id: order.id, status_transition: { event: 'cancel' }, access_token: token.token
      last_response.status.should eq 400
    end

    context 'order in draft status' do
      it 'returns a 200 if place' do
        post api_v1_order_status_transitions_path order_id: order.id, status_transition: { event: 'place' }, access_token: token.token
        last_response.status.should eq 200
      end

      it 'returns a 400 if pay' do
        post api_v1_order_status_transitions_path order_id: order.id, status_transition: { event: 'pay' }, access_token: token.token
        last_response.status.should eq 400
      end

      it 'returns a 200 if cancel' do
        post api_v1_order_status_transitions_path order_id: order.id, status_transition: { event: 'cancel', reason: 'Some reason' }, access_token: token.token
        last_response.status.should eq 200
      end
    end

    context 'order in placed status' do
      before{ post api_v1_order_status_transitions_path order_id: order.id, status_transition: { event: 'place' }, access_token: token.token }

      it 'returns a 400 if place' do        
        post api_v1_order_status_transitions_path order_id: order.id, status_transition: { event: 'place' }, access_token: token.token
        last_response.status.should eq 400
      end

      it 'returns a 200 if pay' do
        post api_v1_order_status_transitions_path order_id: order.id, status_transition: { event: 'pay' }, access_token: token.token
        last_response.status.should eq 200
      end

      it 'returns a 200 if cancel' do
        post api_v1_order_status_transitions_path order_id: order.id, status_transition: { event: 'cancel', reason: 'Some reason' }, access_token: token.token
        last_response.status.should eq 200
      end
    end

    context 'order in payed status' do
      before do 
        post api_v1_order_status_transitions_path order_id: order.id, status_transition: { event: 'place' }, access_token: token.token
        post api_v1_order_status_transitions_path order_id: order.id, status_transition: { event: 'pay' }, access_token: token.token
      end

      it 'returns a 400 if place' do        
        post api_v1_order_status_transitions_path order_id: order.id, status_transition: { event: 'place' }, access_token: token.token
        last_response.status.should eq 400
      end

      it 'returns a 400 if pay' do
        post api_v1_order_status_transitions_path order_id: order.id, status_transition: { event: 'pay' }, access_token: token.token
        last_response.status.should eq 400
      end

      it 'returns a 400 if cancel' do
        post api_v1_order_status_transitions_path order_id: order.id, status_transition: { event: 'cancel', reason: 'Some reason' }, access_token: token.token
        last_response.status.should eq 400
      end
    end

    context 'order in payed status' do
      before do 
        post api_v1_order_status_transitions_path order_id: order.id, status_transition: { event: 'cancel', reason: 'Some reason' }, access_token: token.token
      end

      it 'returns a 400 if place' do        
        post api_v1_order_status_transitions_path order_id: order.id, status_transition: { event: 'place' }, access_token: token.token
        last_response.status.should eq 400
      end

      it 'returns a 400 if pay' do
        post api_v1_order_status_transitions_path order_id: order.id, status_transition: { event: 'pay' }, access_token: token.token
        last_response.status.should eq 400
      end

      it 'returns a 400 if cancel' do
        post api_v1_order_status_transitions_path order_id: order.id, status_transition: { event: 'cancel', reason: 'Some reason' }, access_token: token.token
        last_response.status.should eq 400
      end
    end
  end
end