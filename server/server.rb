require 'eventmachine'
require 'em-http'
require 'json'
require 'em-hiredis'

# usage = "#{$0} <user> <password>"
abort usage unless user ="_bucketsoftears"
abort usage unless password = "bucketsoftears1234"

url = 'https://_bucketsoftears:bucketsoftears1234@stream.twitter.com/1/statuses/filter.json?track=crying'

def handle_tweet(tweet)
  return unless tweet['text']
  puts tweet.to_json
  @pub.publish("tears", tweet.to_json)
end

def join_redis
  redis_details =  YAML.load_file( ZooniverseLive::Application.root('../config/redis.yml'))
  @pub = EM::Hiredis.connect("redis://:#{redis_details['password']}@#{redis_details["host"]}:#{redis_details["port"]}/#{redis_details["db"]}")
end

EventMachine.run do
  
  http = EventMachine::HttpRequest.new(url).get 
  buffer = ""

  http.stream do |chunk|
    buffer += chunk
    while line = buffer.slice!(/.+\r?\n/)
      handle_tweet JSON.parse(line)
    end
  end
end