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

    include RemoteAssociations::ActiveRecord::RelationExtensions
  end
end
