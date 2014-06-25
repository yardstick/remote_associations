module RemoteAssociations::ActiveRecord::RelationExtensions
  include RemoteAssociations::CollectionExtensions

  def self.included(base)
    base.class_eval do
      alias_method :exec_queries_without_remote_associations, :exec_queries
      alias_method :exec_queries, :exec_queries_with_remote_associations
    end
  end

  def exec_queries_with_remote_associations
    exec_queries_without_remote_associations
    preload_remote_associations
    @records
  end
end
