module RemoteAssociations
  module ActiveRecord
    require 'active_record'
    require 'remote_associations/active_record/relation_extensions'
  end
end

ActiveRecord::Relation.send(:prepend, RemoteAssociations::ActiveRecord::RelationExtensions)
