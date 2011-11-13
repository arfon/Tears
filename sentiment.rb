require 'rubygems'
require 'net/http'
require 'json'

class Sentiment
  attr_accessor :text
  def initialize(text)
    self.text = text
    uri = URI('http://text-processing.com/api/sentiment/')
    response = Net::HTTP.post_form(uri, 'text' => text)
    @data = JSON.parse(response.body)
  end

  def method_missing(m, *args, &block)
    # so nasty
    method = m.to_s
    if method == 'label'
      @data['label']
    else
      @data['probability'][method]
    end
  end
end


s1 = Sentiment.new("I just hate when I'm watchin a movie, and a sad part happens, then they make it worse with the sad music... #crying I'm all emotional now")
puts s1.text
puts s1.label
puts s1.neg
puts

s2 = Sentiment.new("When people commit suicide people are like 'it's a shame; they were so beautiful.' Maybe you should have told them that when they were alive")
puts s2.text
puts s2.label
puts s2.neg
puts

s3 = Sentiment.new("I want to make my suicide look like it was intentional.")
puts s3.text
puts s3.label
puts s3.neg
puts

s4 = Sentiment.new("Dear anyone considering suicide: Please dont give up. You are needed. You are wanted. You are important. You are loved. You are beautiful.")
puts s4.text
puts s4.label
puts s4.neg
puts
