class MiseryAction < Cramp::Action

  on_start :create_redis,:handle_join
  on_finish :destroy_redis
#  periodic_timer :check_activities, :every => 15
  self.transport = :sse
  
  def create_redis
    @sub = EM::Hiredis.connect("redis://redistogo:b616b0fd23a137abbc54c213f4fc80c0@tetra.redistogo.com:9420/")
    subscribe
  end
  
  def destroy_redis
    puts "lost user :-("
    @sub.close_connection_after_writing
  end
  def handle_join
    @user_count ||=0
    @user_count +=1
    puts "user joined"
    
  end
  
  
  private

  def subscribe
    @sub.subscribe('tears')
    @sub.on(:message) {|channel, message| push_out(message) }    
  end
  
  def push_out(message)
    puts message
    render message
  end
  
end