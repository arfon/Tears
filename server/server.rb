require 'eventmachine'
require 'em-http'
require 'json'
require 'em-hiredis'

# usage = "#{$0} <user> <password>"
abort usage unless user ="_bucketsoftears"
abort usage unless password = "bucketsoftears1234"

url = 'https://_bucketsoftears:bucketsoftears1234@stream.twitter.com/1/statuses/filter.json?track=crying'
host = "_bucketsoftears:bucketsoftears1234@stream.twitter.com"
request = "1/statuses/filter.json"
query= "track=crying"
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

    http = EM::HttpRequest.new(url, :ssl=>true).get
  # buffer = ""
  #  puts url
  #  conn = EM::Protocols::HttpClient2.connect(:host => host,
  #      :port => 80,
  #     :request => request,
  #     :query_string => query,
  #     :ssl=>true)
  #
  #  req = conn.get('/')
  #  req.callback{ |response|
  #    puts 'responce is #{response.to_json}'
  #    buffer += response
  #    while line = buffer.slice!(/.+\r?\n/)
  #      puts line
  #      #handle_tweet JSON.parse(line)
  #    end
  #  }



  http.stream do |chunk|
      buffer += chunk
      while line = buffer.slice!(/.+\r?\n/)
        puts line
        #handle_tweet JSON.parse(line)
      end
    end
end