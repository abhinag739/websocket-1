require "place_bid"
class BidsController < ApplicationController

  def create
    place_bid_object = PlaceBid.new allowed_params
    if place_bid_object.execute
      redirect_to product_path(params[:product_id]), notice: "The Bid was placed successfully"
    else
      redirect_to product_path(params[:product_id]), alert: "Bid has to be higher then current_bid"
    end
  end
  
  
  private 
  
  def allowed_params
    params.require(:bid).permit(:value).merge!( 
      user_id:  current_user.id,
      auction_id: params[:auction_id],
      name: current_user.name
    )
  end
  
    
end