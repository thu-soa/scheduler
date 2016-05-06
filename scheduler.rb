require 'sinatra'
require './main'
require './errors'

get '/api/v1/unread_messages' do
  if (token = Token.find_by_token_string(params['token']))
    messages = Message.where(user_id: token.user.id)
    { status: :ok, simple_messages: messages }.to_json
  else
    er 'token error'
  end
end
get '/api/v1/sources/:source_name/unread_messages' do
  if (token = Token.find_by_token_string(params['token']))
    messages = Message.where(
        'user_id = :user_id and source = :source',
        user_id: token.user.id, source: params[:source_name])
    { status: :ok, simple_messages: messages }.to_json
  else
    er 'token error'
  end
end

post '/api/v1/unread_messages', &(lambda do
  er 'json http param not found' unless params.key? 'json'
  json = JSON.parse params['json']
  er 'simple_message not found' unless json['simple_message']&.is_a?(Hash)
  message = json['simple_message']

  if (token = params['token']) && (t = Token.find_by_token_string(token))
    er 'user type not matched' unless t.user.user_type.to_sym == :source
    er 'no token' unless token

    # check allowed properties
    properties = %w'title user_id source url'
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
    er 'token error'
  end
end)