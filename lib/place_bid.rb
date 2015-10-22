class PlaceBid
  attr_reader :auction, :status
  def initialize options
    @value = options[:value].to_f
    @user_id = options[:user_id].to_i
    @auction_id = options[:auction_id].to_i
    @user_name = options[:user_name].to_s
  end
  
  def execute
    @auction =  Auction.find @auction_id
    
    if auction.ended? && auction.top_bid.user_id == @user_id
      @status = :won
      return false
    end
      
    if @value <= auction.current_bid
      return false
    end
    bid = auction.bids.build value: @value, user_id: @user_id, user_name: @user_name
  
  if bid.save
    return true
  else
    return false  
  end
 
 end
  
end