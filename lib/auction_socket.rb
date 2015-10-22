require File.expand_path "../place_bid", __FILE__

class AuctionSocket
  def initialize app
    @app = app
    @clients = []
  end
  
  def call env
    @env = env
      if socket_request?
        socket = spawn_socket
        @clients << socket
        socket.rack_response
      else
        # else goes to the next middleware
        @app.call env
    end
    
end

private 

attr_reader :env

  def socket_request?
    Faye::WebSocket.websocket? env
  end
  
  def spawn_socket 
    socket = Faye::WebSocket.new env
      socket.on :open do
        socket.send "Hello!"
      end
      
      socket.on :message do |event|
        socket.send event.data
        begin
          bidvals = event.data.split " "
          operation = bidvals.delete_at 0
          case operation
            when "bid"
              bid socket, bidvals
            end
            
           rescue Exception => e
            p e
            p e.backtrace
          end
      end
      
      
  socket      
  end
  
  def bid socket, bidvals
    service = PlaceBid.new(
      auction_id: bidvals[0], 
      user_name: bidvals[1],
      user_id: bidvals[2],
      value: bidvals[3]
    )
   if service.execute
    
    socket.send "bidok"
    notify_clients socket, bidvals[3]
  else
    if service.status == :won
      notify_auction_won_or_lost socket
    else
      socket.send "underbid #{service.auction.current_bid}"    
    end
  end
  end
  
  def notify_auction_won_or_lost socket
    socket.send "won"
    @clients.reject { |client| client == socket || !same_path?(client,socket) }.each do |client|
      client.send "lost"
    end
  end
  
  def notify_clients socket, value
    @clients.reject { |client| client == socket || !same_auction_path?(client,socket) }.each do |client|
      client.send "outbid #{value}"
    end
  end
  
  def same_auction_path? other_socket, socket
    other_socket.env["REQUEST_ENV"] == socket.env["REQUEST_ENV"]
  end
end