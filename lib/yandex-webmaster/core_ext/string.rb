# encoding: utf-8

class String # :nodoc:
  def demodulize
    if i = self.rindex('::')
      self[(i+2)..-1]
    else
      self
    end
  end unless method_defined?(:demodulize)
end