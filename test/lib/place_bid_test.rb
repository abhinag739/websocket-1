require "test_helper" 

require "place_bid"

class PlaceBidTest < Minitest::Test
  
  def setup
    @user = User.create! email: "ab7393@gmail.com", password: "123123123", name: "blob"
    @another_user = User.create! email: "ab7394@gmail.com", password: "123123123"
    @product = Product.create! name: "test product"
    @auction = Auction.create! value: 11, product_id: product.id, ends_at: Time.now  + 24.hours
  end
  
 
 def test_one
     service = PlaceBid.new(
     value: 19,
     user_id: user.id,
     auction_id: auction.id,
     user_name: user.name
     )
  service.execute
     
     another_service = PlaceBid.new(
     value: 1000,
     user_id: user.id,
     auction_id: auction.id,
     user_name: user.name
     )
     Timecop.travel Time.now + 25.hours
     another_service.execute
     assert_equal :won, another_service.status
     
 end
  
  private 
  
  attr_reader :user, :product, :another_user, :auction
  
end
                                                                                                              