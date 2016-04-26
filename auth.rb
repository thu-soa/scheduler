require 'sinatra'
require './main'
require './app/models/user'
require './app/models/oauth_token'
require './errors'

#  OAuth 2.0
# require 'rack-oauth2'
# authorization_endpoint = Rack::OAuth2::Server::Authorize.new do |req, res|
#   client = User.find_by_id(req.client_id)
#   req.bad_request! if client.blank?
#   res.redirect_uri = req.verify_redirect_uri!(client.redirect_uri)
#   if req.post?
#     if params[:approve]
#       case req.response_type
#         when :code
#           authorization_code = current_account.authorization_codes.create(
#               client: client,
#               redirect_uri: res.redirect_uri
#           )
#           res.code = authorization_code.token
#         when :token
#           req.unsupported_response_type!
#       end
#       res.approve!
#     else
#       req.access_denied!
#     end
#   else
#     [404, [], []]
#   end
# end
#
# authorization_endpoint.call request.env

post '/api/users/verify' do

end

get '/api/users/token' do
  uid = params['id']
  source = params['source']
  { status: :ok }
end

