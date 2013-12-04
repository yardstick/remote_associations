module RemoteAssociations
  class Relation
    prepend RemoteAssociations::ActiveRecord::RelationExtensions

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
  end
end
