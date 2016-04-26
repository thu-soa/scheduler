require 'active_record'
require 'foreigner'

class User < ActiveRecord::Base
  has_many :oauth_tokens
end