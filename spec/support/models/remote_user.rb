class RemoteUser
  include ActiveModel::Model

  attr_accessor :id

  def self.all(token, options = {})
    options.fetch(:ids).map { |e| new(:id => e) }
  end

  def self.find(token, id)
    new(:id => id)
  end
end
