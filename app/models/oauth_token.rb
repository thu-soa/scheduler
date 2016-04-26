require 'active_record'
require 'foreigner'

class OauthToken < ActiveRecord::Base
  belongs_to :user
end