class RemoteAssociations::RemoteAssociation
  attr_accessor :name, :options, :fetch_block

  def initialize(name, options = {}, &fetch_block)
    @name = name
    @options = options
    @fetch_block = fetch_block
  end

  def klass
    return options[:class] if options.has_key?(:class)
    raise ArgumentError, "Specifying the class is required for the time being"
  end

  def foreign_key
    return options[:foreign_key] if options.has_key?(:foreign_key)
    :"#{name}_id"
  end

  def primary_key
    :id
  end

  def member
    :"@#{getter}"
  end

  def getter
    :"#{@name}"
  end

  def setter
    :"#{getter}="
  end
end
