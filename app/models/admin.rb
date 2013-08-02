class Admin < User
  def method_missing(name, *args)
    super
  end
end