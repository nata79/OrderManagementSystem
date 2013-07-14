class Api::V1::StatusTransitionsController < Api::V1::BaseController
  before_filter :load_order

  def index
    @transitions = @order.transitions
  end

  def create
    @transition = @order.transitions.create! transition_params
    render :show
  end
private
  def load_order
    @order = Order.find params[:order_id]
  end

  def transition_params
    params.require(:status_transition).permit(:event, :reason)
  end
end