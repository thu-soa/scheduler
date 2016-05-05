require 'sinatra'
require './main'
require './errors'

get '/api/v1/unread_messages' do
  Message.all.to_json
end

post '/api/v1/unread_messages', &(lambda do
  er 'json http param not found' unless params.key? 'json'
  json = JSON.parse params['json']
  er 'message not found' unless json['message']&.is_a?(Hash)
  message = json['message']
  token = json['token']
  if token
    # check allowed properties
    properties = %w'title user_id'
    # reject all invalid parameters
    message.reject! { |key, val| not properties.include? key }
    # check all required parameters
    properties.each { |x| er "missing property `#{x}'" unless message.key? x }

    if (m = Message.create message)
      { message_id: m.id, status: :ok }.to_json
    else
      er 'db error'
    end
  else
    er 'no token'
  end
end)