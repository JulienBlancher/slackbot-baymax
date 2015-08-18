require 'slack-ruby-client'
require './config.rb'

Slack.configure do |config|
	  config.token = CONFIG[:api_token]
end

client = Slack::RealTime::Client.new

client.on :hello do
	puts "Successfully connected, welcome '#{client.self['name']}' to the '#{client.team['name']}' team at https://#{client.team['domain']}.slack.com."
end


client.on :message do |data|
  case data['text']
  when 'baymax hi' then
    client.web_client.chat_postMessage channel: data['channel'], text: "Hi <@#{data['user']}>!", as_user: true
  when /^baymax/ then
    client.message channel: data['channel'], text: "Sorry <@#{data['user']}>, what?"
  #else 
  #	  channel = client.web_client.channels_info channel: data['channel']
  #	  user = client.web_client.users_info user: data['user']
  #	  puts "Received a message on channel #{data['channel']} from #{user['name']}: #{data['text']}"
  end
end

client.on :user_typing do |data|
	client.message channel: data['channel'], text: "I can see <@#{data['user']}> typing :ghost:"
end

#client.on :presence_change do |data|
#	p "Presence Change"
#    p data
#	if data['presence'] == 'active'
#		client.web_client.chat_postMessage channel: data['user'], text: "Welcome back, <#{data['user']}> ! If you need anything, I'm here"
#	end
#end

client.start!
