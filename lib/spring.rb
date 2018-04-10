class Spring
  attr_reader :source, :target, :length

  DEFAULT_SPRING_LENGTH = 20
  STIFFNESS = 200.0

  def initialize(source, target, length)
    @source = source
    @target = target
    @length = length
  end
end
