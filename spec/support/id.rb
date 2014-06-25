module Id
  @@id = 0

  def self.generate
    @@id = @@id + 1
  end
end
