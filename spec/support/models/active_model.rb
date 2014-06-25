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
end
