class Spring
  attr_reader :source, :target, :length

  def initialize(source, target, length)
    @source = source
    @target = target
    @length = length
  end
end
