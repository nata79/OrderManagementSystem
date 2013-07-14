class Api::V1::ProductsController < Api::V1::BaseController
  before_filter :load_product, except: [:index, :create]

  def index
    @products = Product.all
  end

  def show    
  end

  def create
    @product = Product.create! product_params
    render :show
  end

  def update
    @product.update_attributes product_params
    render :show
  end

  def destroy
    if @product.destroy
      render :show
    else
      send_error 'Product cannot be destroyed', :bad_request
    end    
  end
private
  def load_product
    @product = Product.find params[:id]
  end

  def product_params
    params.require(:product).permit(:name, :net_price_pennies, :net_price_currency)
  end
end