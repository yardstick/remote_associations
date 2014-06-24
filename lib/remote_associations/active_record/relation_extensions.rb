module RemoteAssociations::ActiveRecord::RelationExtensions
  include RemoteAssociations::CollectionExtensions

  def exec_queries
    super
    preload_remote_associations
    @records
  end
end
