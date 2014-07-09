module RemoteAssociations::ActiveModel
  def initialize(params={})
    params.each do |attr, value|
      self.public_send("#{attr}=", value)
    end if params

    super()
  end

  def persisted?
    false
  end

  def ==(other)
    return false unless self.class == other.class
    self.class.attributes.each do |attribute|
      return false unless send(attribute) == other.send(attribute)
    end
    true
  end

  def self.included(base)
    base.class_eval do
      def self.attributes(*args)
        @attributes ||= []
        return @attributes unless args.length > 0
        @attributes.concat(args)
        attr_accessor *args
      end
    end
  end
end
