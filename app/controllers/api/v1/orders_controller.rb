class Api::V1::OrdersController < Api::V1::BaseController
  before_filter :load_order, except: [:index, :create]

  def index
    @orders = Order.all
  end

  def show    
  end

  def create
    @order = Order.create! order_params
    render :show
  end

  def update
    @order.update_attributes! order_params
    render :show
  end
private
  def load_order
    @order = Order.includes(line_items: :product).find(params[:id])
  end

  def order_params
    params.require(:order).permit(:order_date, :vat)
  end
end