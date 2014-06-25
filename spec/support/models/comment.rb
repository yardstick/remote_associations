require 'support/models/remote_post'
require 'support/models/user'

class Comment
  include ActiveModel::Model
  include RemoteAssociations

  belongs_to_remote(:post, :class => RemotePost)
  belongs_to_remote(:post_uses_token) { auth_token }
  belongs_to_remote(:user, :class => RemoteUser)

  attr_accessor :post_id, :user_id
end
