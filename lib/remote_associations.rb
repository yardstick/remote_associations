require 'active_support'

require 'remote_associations/version'
require 'remote_associations/errors'
require 'remote_associations/remote_association'

module RemoteAssociations
  extend ActiveSupport::Concern

  module Helpers
    module_function

    def variable_from(method)
      :"@#{method}"
    end

    def setter_for(method)
      :"#{method}="
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

  module ClassMethods
    def remote_associations
      @remote_associations ||= {}
    end

    def belongs_to_remote(name, options = {}, &block)
      association = remote_associations[name] = RemoteAssociation.new(name, options, &block)

      define_method(association.getter) do |token = nil|
        value = instance_variable_get(association.member)
        return value if value.present?

        if association.fetch_block.nil?
          instance_variable_set(association.member, association.klass.find(token, send(association.foreign_key)))
        else
          instance_variable_set(association.member, instance_exec(&association.fetch_block))
        end
      end

      define_method(association.setter) do |value|
        raise Errors::AssociationTypeMismatch, "expected #{association.klass.name} got #{value.class.name})" unless value.is_a?(association.klass)
        instance_variable_set(association.member, value)
        send(Helpers::setter_for(association.foreign_key), value.send(association.primary_key))
      end
    end

    alias has_remote_equivalent belongs_to_remote
  end
end

ActiveSupport.on_load(:active_record) do
  require 'remote_associations/active_record'
  ActiveRecord::Relation.send(:prepend, RemoteAssociations::ActiveRecord::RelationExtensions)
end
