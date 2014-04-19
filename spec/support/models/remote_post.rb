class RemotePost
  include ActiveModel::Model

  attr_accessor :id

  def self.find(token, id)
    new(:id => id)
  end
end
