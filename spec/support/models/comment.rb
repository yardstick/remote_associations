require 'support/models/remote_post'

class Comment
  include ActiveModel::Model
  include RemoteAssociations

  belongs_to_remote(:post, class: RemotePost)
  belongs_to_remote(:post_uses_token) { auth_token }
  belongs_to_remote(:user_missing_block)

  attr_accessor :post_id
end
