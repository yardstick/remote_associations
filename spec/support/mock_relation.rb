require 'remote_associations/active_record'

module RemoteAssociations
  class Relation

    attr_accessor :model

    def initialize(records)
      @records = records
      @model = records.first.class unless records.empty?
    end

    def exec_queries
      @records
    end

    def spawn
      self
    end

    # alias_method_chain doesn't know about exec_queries unless we put this down here
    include RemoteAssociations::ActiveRecord::RelationExtensions
  end
end
