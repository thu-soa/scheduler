require 'sinatra'
require 'http'
require './main'
require './errors'

after do
  ActiveRecord::Base.connection.close
end

# TODO Here we can use a cache to reduce requests
def get_user_by_token(token)
  response = HTTP.get(URI("#{USER_INFO_URL}?token=#{token}"))
  begin
    json = JSON.parse(response)
    if json['status'] == 'ok'
      json
    else
      nil
    end
  rescue JSON::JSONError
    raise 'auth returns garbage'
  end
end

get '/api/v1/unread_messages' do
  user = get_user_by_token(params['token'])
  if user
    user_id = user['id']
    messages = Message.where(user_id: user_id)
    { status: :ok, simple_messages: messages }.to_json
  else
    er 'token error'
  end
end

get '/api/v1/sources/:source_name/unread_messages' do
  user = get_user_by_token(params['token'])
  if user
    user_id = user['id']
    messages = Message.where(
        'user_id = :user_id and source = :source',
        user_id: user_id, source: params[:source_name])
    { status: :ok, simple_messages: messages }.to_json
  else
    er 'token error'
  end
end

def add_message(message)
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
end

post '/api/v1/unread_messages', &(lambda do
  er 'json http param not found' unless params.key? 'json'
  json = JSON.parse params['json']
  er 'simple_message not found' unless [Hash, Array].include?(json['simple_message'].class)
  message = json['simple_message']

  user = get_user_by_token(params['token'])
  if (token = params['token']) && (user)
    user_type = user['user_type']
    er 'user type not matched' unless user_type == 'source'
    er 'no token' unless token

    if message.is_a?(Array)
      message.each { |m| add_message(m) }
    else # message.is_a?(Hash)
      add_message(message)
    end
    { status: 'ok' }.to_json
  else
    er 'token error'
  end
end)