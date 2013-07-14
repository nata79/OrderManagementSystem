require 'spec_helper'

describe '/api/v1/products', type: :api do
  before { host! 'example.org' }

  let(:product_count) { 10 }
  before { product_count.times { create :product } }

  describe '#index' do
    before { get api_v1_products_path }

    it { last_response.status.should eq 200 }

    it 'should return 10 products' do
      products = JSON.parse last_response.body
      products.count.should eq 10
    end
  end

  describe '#show' do
    let(:product) { Product.first }

    it { get api_v1_product_path(product); last_response.status.should eq 200 }

    it 'returns the id, name, price and location' do
      get api_v1_product_path(product)
      json_product = JSON.parse last_response.body
      json_product['id'].should eq product.id
      json_product['name'].should eq product.name
      json_product['net_price_pennies'].should eq product.net_price_pennies
      json_product['net_price_currency'].should eq product.net_price_currency
      json_product['location'].should eq api_v1_product_url(product)
    end

    it 'returns a 404 if the product does not exist' do 
      get api_v1_product_path id: 20
      last_response.status.should eq 404 
    end
  end

  describe '#create' do
    it 'returns a 400 if the product has no name' do 
      post api_v1_products_path product: { net_price_pennies: 100, net_price_currency: 'GBP' }
      last_response.status.should eq 400
    end

    it 'returns a 400 if the product has no net_price' do 
      post api_v1_products_path product: { name: 'Invalid Product' }
      last_response.status.should eq 400
    end

    it 'returns a 200 if the product is valid' do
      post api_v1_products_path product: { name: 'Valid Product', net_price_pennies: 100, net_price_currency: 'GBP' }
      last_response.status.should eq 200
    end
  end

  describe '#update' do
    let(:product) { Product.first }

    it 'returns a 200 if the product is valid' do
      put api_v1_product_path product: { name: 'Valid Product', net_price_pennies: 100 }, id: product.id
      last_response.status.should eq 200
    end

    it 'returns a 400 if the net_price is 0' do 
      put api_v1_product_path product: { name: 'Valid Product', net_price_pennies: 0 }, id: product.id
      last_response.status.should eq 400
    end    

    it 'returns a 404 if the product does not exist' do
      put api_v1_product_path product: { name: 'Valid Product', net_price_pennies: 100 }, id: 0
      last_response.status.should eq 404
    end
  end

  describe '#destroy' do
    let(:product) { Product.first }

    it 'returns a 200 if the product was never used in an order' do
      delete api_v1_product_path id: product.id
      last_response.status.should eq 200
    end

    it 'returns a 400 if the product was used in an order' do
      order = create :order
      create :line_item, order: order, product: product
      delete api_v1_product_path id: product.id
      last_response.status.should eq 400
    end

    it 'returns a 404 if the product does not exist' do
      delete api_v1_product_path id: 0
      last_response.status.should eq 404
    end
  end
end