class OrdersController < ApplicationController
  def show
    @items = Item.to_buy.joins(:group).order('groups.position, items.position')
  end

  def destroy
    Item.update_all(confirmed: false)
    redirect_to order_path, notice: 'Confirmations cleared.'
  end

  def confirm_item
    update_confirmation(true)
  end

  def unconfirm_item
    update_confirmation(false)
  end

  private

  def item
    @item ||= Item.find(params[:item_id])
  end

  def update_confirmation(confirmed)
    item.update!(confirmed: confirmed)
    render json: { html: render_to_string(partial: 'orders/item', locals: { item: item }), confirmed: item.confirmed }
  end
end