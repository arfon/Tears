require 'json/pure'

class MiseryAction < Cramp::Action
  
  on_start :create_redis,:handle_join
  on_finish :destroy_redis
#  periodic_timer :check_activities, :every => 15
  self.transport = :sse
  
  def create_redis
    @sub = EM::Hiredis.connect("redis://redis.bucketsoftears.com:6379/")
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
    @sub.on(:message) {|channel, message| get_semantic(message) }    
  end

  def get_semantic(message)
    parsed = JSON.parse(message)
    text = parsed['text']

    EventMachine.run {
      http = EventMachine::HttpRequest.new('http://text-processing.com/api/sentiment/').post :body => {'text' => text}

      http.errback { p 'Uh oh' }
      http.callback {
        sentiment = JSON.parse(http.response)['label']
        push_out(message, sentiment)
      }
    }
  end
  
  def push_out(message, sentiment)
    parsed = JSON.parse(message)
    parsed[:sentiment] = sentiment
    render parsed.to_json
  end
end