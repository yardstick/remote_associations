class RemoteAssociations::CollectionProxy
  include Enumerable
  include RemoteAssociations::CollectionExtensions

  def initialize(klass = nil, &block)
    @klass = klass
    @block = block
  end

  def each(&block)
    records.each(&block)
  end

  def records
    return @records unless @records.nil?
    @records = @klass.nil? ? @block.call : map_results(@block.call)
    preload_remote_associations
    @records
  end

  def map_results(results)
    results.map { |x| @klass.new(x) }
  end

  # poor mans delegate so we don't have to reference rails
  [
    :[],
    :at,
    :collect,
    :collect!,
    :compact,
    :compact!,
    :count,
    :drop,
    :empty?,
    :include?,
    :fetch,
    :join,
    :last,
    :length,
    :map,
    :map!,
    :reject,
    :reject!,
    :reverse,
    :reverse_each,
    :reverse!,
    :sample,
    :select,
    :select!,
    :size,
    :slice,
    :slice!,
    :sort,
    :sort!,
    :sort_by!,
    :take,
    :take_while,
    :uniq,
    :uniq!,
    :values_at,
    :zip
  ].each do |method|
    define_method(method) do |*args, &block|
      records.send(method, *args, &block)
    end
  end

  def model
    @klass
  end

  def ==(other)
    case other
    when self.class
      records == other.records
    else
      records == other
    end
  end

  def to_s
    "#<#{self.class.name}<#{@klass}>:#{records.to_s}>"
  end

  def inspect
    to_s
  end

private

  def spawn
    clone
  end

  def initialize_copy(i_think_this_is_the_old_one)
    @records = nil
  end
end

ActiveSupport.on_load(:active_model_serializers) do
  begin
    RemoteAssociations::CollectionProxy.send(:include, ActiveModel::ArraySerializer)
  rescue NameError
    RemoteAssociations::CollectionProxy.send(:include, ActiveModel::ArraySerializerSupport)
  end
end
