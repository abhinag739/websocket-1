class AuctionsController < ApplicationController
  def create
    product = Product.find params[:product_id]
    auction = Auction.new auction_params.merge! product_id: product.id, user_name: current_user.name
    
    if auction.save 
      redirect_to product, notice: "The auction was saved successfully"
    else 
      redirect_to product, alert: "Error, please enter an auction value"
    end
  end
  
  def auction_params
    params.require(:auction).permit(:value, :ends_at)
  end
  
end