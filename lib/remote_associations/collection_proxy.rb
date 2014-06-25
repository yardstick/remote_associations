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
    @records ||= @klass.nil? ? @block.call : map_results(@block.call)
    preload_remote_associations
    @records
  end

  def map_results(results)
    results.map { |x| @klass.new(x) }
  end
end

ActiveSupport.on_load(:active_model_serializers) do
  RemoteAssociations::CollectionProxy.class_eval do
    include ActiveModel::ArraySerializerSupport

    def model
      @klass
    end
  end
end
