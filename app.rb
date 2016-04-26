require 'sinatra'
require './main'
require './errors'

get '/api/messages' do
  Message.all.to_json
end

post '/api/message', &(lambda do
  er 'json http param not found' unless params.key? 'json'
  json = JSON.parse params['json']
  er 'message not found' unless json['message']&.is_a?(Hash)
  message = json['message']

  # check allowed properties
  properties = %w'title user_id'
  message.reject! { |key, val| not properties.include? key }
  properties.each { |x| er "missing property `#{x}'" unless message.key? x }

  if Message.create message
    { status: :ok }.to_json
  else
    er 'db error'
  end
end)