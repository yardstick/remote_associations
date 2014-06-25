module RemoteAssociations::CollectionExtensions
  attr_accessor :remote_preloads, :null_discards

  def remote_preloads
    @remote_preloads ||= []
  end

  def null_discards
    @null_discards ||= {}
  end

  def preload_remote_associations
    remote_preloads.each do |association|
      preload_remote_association(association)
    end
  end

  def preload_remote_association(association)
    association = model.remote_associations[association]
    groups = @records.group_by { |record| record.send(association.foreign_key) }
    associated_records = association.klass.all(@auth_token, :ids => groups.keys).group_by { |x| x.id }
    @records.select! do |record|
      remote_value = assign_remote_value(association, record, associated_records)
      if null_discards[association.name]
        remote_value.present?
      else
        true
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

  ##
  # remote inner join essentially
  def joins_remote(association)
    spawn.joins_remote!(association)
  end

  def joins_remote!(association)
    includes_remote!(association)
    self.null_discards[association] = true
    self
  end

  def auth_token(token)
    spawn.auth_token!(token)
  end

  def auth_token!(token)
    @auth_token = token
    self
  end

private

  def assign_remote_value(association, record, associated_records)
    foreign_key_value = record.send(association.foreign_key)
    if associated_records.has_key?(foreign_key_value)
      record.instance_variable_set(association.member, associated_records[foreign_key_value].first)
    end
  end
end
