require 'twitter/json_stream'

class DirectAction < Cramp::Action

  on_start :handle_join
  on_finish :destroy_stream
#  periodic_timer :check_activities, :every => 15
  self.transport = :sse
  
  def create_stream(term)
    @stream = Twitter::JSONStream.connect(
       :path    => "/1/statuses/filter.json?track=#{term}",
       :auth    => '_bucketsoftears:bucketsoftears1234',
       :method  => 'GET',
       :ssl     => true,
       
     )

     @stream.each_item do |item|
        push_out(item) 
     end

     @stream.on_error do |message|
       puts "TWITTER ERROR #{message}"
     end

     @stream.on_max_reconnects do |timeout, retries|
       puts "Connection time out"
     end
  end
  
  def destroy_stream
    puts "destroying"
    @stream.stop()
  end
  def handle_join
    puts "user joined"
    create_stream(params[:term])
  end
  
  
  private

  
  def push_out(message)
    puts message
    render message
  end
  
end