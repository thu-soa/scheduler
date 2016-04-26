require 'sinatra'
require './main'
require './app/models/user'
require './app/models/oauth_token'
require './errors'

get '/api/messages' do
  uid = params['id']
  token = params['token']
  github_token = 'get github token with some method'
  messages = []
  (1..10).to_a.sample.times do
    messages << { title: "title is #{Math.rand(1234566).to_s}", user_id: uid }
  end
  {
      status: :ok,
      id: uid,
      source: 'github',
      messages: messages
  }
end
