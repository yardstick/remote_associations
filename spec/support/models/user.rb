require 'support/models/remote_user'

class User
  include ActiveModel::Model
  include RemoteAssociations

  attr_accessor :username, :id, :permissions

  has_remote_equivalent(:poker_user, :class => RemoteUser) { 'bloop' }
end
