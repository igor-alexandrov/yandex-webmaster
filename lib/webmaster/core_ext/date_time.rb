class DateTime
  def inspect
    self.strftime("%a, %d %b %Y %H:%M:%S %z")
  end
end
