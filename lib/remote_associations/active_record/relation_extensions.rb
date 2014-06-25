module RemoteAssociations::ActiveRecord::RelationExtensions
  include RemoteAssociations::CollectionExtensions

  def self.included(base)
    base.alias_method_chain :exec_queries, :remote_associations
  end

  def exec_queries_with_remote_associations
    exec_queries_without_remote_associations
    preload_remote_associations
    @records
  end
end
