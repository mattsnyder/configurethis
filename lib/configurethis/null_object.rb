class NullObject
 def initialize
    @origin = caller.first ### SETS ORIGIN FOR INSPECT INFO
  end

  def method_missing(*args, &block)
    self
  end

  def nil?; true; end
end

# Use to select between blank value and a default value
def Prefer(value)
  if value.respond_to?(:empty?) ? value.empty? : !value
    yield
  else
    value
  end
end

# Use to protect against nils
def Maybe(value)
  if value.nil? then
    block_given? ? yield : NullObject.new
  else
    value
  end
end
