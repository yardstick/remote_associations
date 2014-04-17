require 'active_support'

require 'remote_associations/version'
require 'remote_associations/errors'
require 'remote_associations/remote_association'

module RemoteAssociations
  extend ActiveSupport::Concern

  module Helpers
    extend self

    def variable_from(method)
      :"@#{method}"
    end
  end

  attr_accessor :auth_token

  def auth_token
    raise RemoteAssociations::Errors::MissingTokenError, "Auth token must be set in order to be used in remote associations" if @auth_token.nil?
    @auth_token
  end

  def remote_associations
    self.class.remote_associations
  end

  def method_missing(method, *args, &block)
    return super unless remote_associations.has_key?(method)
    value = instance_variable_get(Helpers.variable_from(method))
    return value unless value.nil?

    if remote_associations[method].fetch_block.nil?
      raise RemoteAssociations::Errors::MissingFetchBlockError, "Fetch block not given for remote association: #{method.to_s}"
    end

    value = instance_exec(&remote_associations[method].fetch_block)
    instance_variable_set(Helpers.variable_from(method), value)
  end

  def respond_to_missing?(method, include_priv = false)
    return true if remote_associations.has_key?(method)
    super
  end

  module ClassMethods
    def remote_associations
      @remote_associations ||= {}
    end

    def belongs_to_remote(name, options = {}, &block)
      remote_associations[name] = RemoteAssociation.new(name, options, &block)
    end

    alias has_remote_equivalent belongs_to_remote
  end
end

require 'remote_associations/active_record'
