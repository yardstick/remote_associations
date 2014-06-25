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
    return @records if @records.present?
    @records = @klass.nil? ? @block.call : map_results(@block.call)
    preload_remote_associations
    @records
  end

  def map_results(results)
    results.map { |x| @klass.new(x) }
  end

  # poor mans delegate so we don't have to reference rails
  [:last, :length, :size, :count].each do |method|
    define_method(method) { records.send(method) }
  end

  def model
    @klass
  end

private

  def spawn
    clone
  end
end

ActiveSupport.on_load(:active_model_serializers) do
  RemoteAssociations::CollectionProxy.send(:include, ActiveModel::ArraySerializerSupport)
end
