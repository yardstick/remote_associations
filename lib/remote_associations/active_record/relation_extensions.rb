module RemoteAssociations::ActiveRecord::RelationExtensions
  attr_accessor :remote_preloads

  def remote_preloads
    @remote_preloads ||= []
  end

  def exec_queries
    records = super
    remote_preloads.each do |association|
      preload_remote_association(association)
    end
    records
  end

  def preload_remote_association(association)
    association = model.remote_associations[association]
    groups = @records.group_by { |record| record.send(association.foreign_key) }
    associated_records = association.klass.all(@auth_token, ids: groups.keys).group_by { |x| x.id }
    @records.each do |record|
      foreign_key = record.send(association.foreign_key)
      if associated_records.has_key?(foreign_key)
        record.instance_variable_set(Helpers::variable_from(association.name), associated_records[foreign_key].first)
      end
    end
  end

  def includes_remote(association)
    spawn.includes_remote!(association)
  end

  def includes_remote!(association)
    self.remote_preloads = (remote_preloads + [association]).flatten.uniq
    self
  end

  def auth_token(token)
    spawn.auth_token!(token)
  end

  def auth_token!(token)
    @auth_token = token
    self
  end
end
