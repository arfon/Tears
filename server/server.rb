require 'rubygems'
require 'em-hiredis'
require 'tweetstream'
require 'json'

TweetStream.configure do |config|
 config.username = '_bucketsoftears'
 config.password = 'bucketsoftears1234'
 config.auth_method = :basic
 config.parser   = :yajl
end

count = 0
TweetStream::Client.new.track('crying, tears, cried') do |status|
 puts count += 1
 @redis ||= EM::Hiredis.connect("redis://redis.bucketsoftears.com:6379/1")


 @redis.publish("tears2", status.to_json).errback { |e| p [:publisherror, e] }
end