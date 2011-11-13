require 'eventmachine'
require 'em-http'
require 'json'

usage = "#{$0} <user> <password>"
abort usage unless user = ARGV.shift
abort usage unless password = ARGV.shift

url = 'http://stream.twitter.com/1/statuses/sample.json'

def handle_tweet(tweet)
  return unless tweet['text']
  puts "#{tweet['user']['screen_name']}: #{tweet['text']}"
end

EventMachine.run do
  http = EventMachine::HttpRequest.new(url).get :head => { 'Authorization' => [ user, password ] }

  buffer = ""

  http.stream do |chunk|
    buffer += chunk
    while line = buffer.slice!(/.+\r?\n/)
      handle_tweet JSON.parse(line)
    end
  end
end