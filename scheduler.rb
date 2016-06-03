require 'sinatra'
require 'http'
require './main'
require './errors'
require 'net/http'
require 'sinatra/cross_origin'
configure do
  enable :cross_origin
end

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
    user_id = user['user_id']
    messages = Message.where(user_id: user_id)
    { status: :ok, simple_messages: messages }.to_json
  else
    er 'token error'
  end
end

get '/api/v1/sources/:source_name/unread_messages' do
  user = get_user_by_token(params['token'])
  if user
    user_id = user['user_id']
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
  required_properties = %w'title user_id source url'
  optional_properties = %w'description'
  # reject all invalid parameters
  message.reject! { |key, val| not (required_properties + optional_properties).include? key }
  # check all required parameters
  required_properties.each { |x| er "missing property `#{x}'" unless message.key? x }

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

delete '/api/v1/unread_messages', &(lambda do
  token = params['token']
  id = params['id']
  user = get_user_by_token(token)
  begin
    message = Message.find(id)
  rescue ActiveRecord::RecordNotFound
    er 'invalid message id'
  end

  if (token = params['token']) && user
    if user.id == message.user_id
      message.destroy
    else
      er 'not your message'
    end
  end
  { status: :ok }.to_json
end)

get '/api/v1/all_sources' do
  user = get_user_by_token(params['token'])
  if user
    user_id = user['user_id']
    sources = {}
    # each adapter, check registered
    ADAPTER_URLS.each do |source, url_main|
      u = url_main + "/api/v1/check_registered?id=#{user_id}&token=#{params['token']}"
      response = Net::HTTP.get(URI(u))
      json  = JSON.parse(response)
      if json['status'] == 'ok'
        sources[source] = url_main
      end
    end
    { status: :ok, sources: sources }.to_json
  else
    er 'token error'
  end
end
