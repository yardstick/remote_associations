class RemotePost
  include RemoteAssociations::ActiveModel

  attr_accessor :id

  def self.find(token, id)
    new(:id => id)
  end
end
