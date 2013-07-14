class Api::V1::LineItemsController < Api::V1::BaseController
  before_filter :load_order
  before_filter :load_line_item, except: [:index, :create]

  def index
    @line_items = @order.line_items
  end

  def show    
  end

  def create
    @line_item = @order.line_items.create! line_item_params
    render :show
  end

  def update
    @line_item.update_attributes! line_item_params
    render :show
  end

  def destroy
    if @line_item.destroy
      render :show
    else
      send_error 'Line item cannot be destroyed', :bad_request
    end    
  end
private
  def load_order
    @order = Order.find params[:order_id]
  end

  def load_line_item
    @line_item = @order.line_items.find params[:id]
  end

  def line_item_params
    params.require(:line_item).permit(:quantity, :product_id)
  end
end