class Auction < ActiveRecord::Base
  belongs_to :product
  has_many :bids
  
  
  def current_bid
    top_bid.nil? ? value : top_bid.value
  end
  

  def top_bid
    bids.order(value: :desc).first
  end
 
 def top_bidder_name
   top_bid.user[:name]
 end
  
 def ended?
   ends_at < Time.now
 end
 
end
