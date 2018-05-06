module ForceLayout
  class Spring
    attr_reader :source, :target, :length

    # Main Point!
    DEFAULT_SPRING_LENGTH = 20
    STIFFNESS = 200.0

    def initialize(source, target, length)
      @source = source
      @target = target
      @length = length
    end

    def self.default_length
      ForceLayout.settings[:spring_default_length] || DEFAULT_SPRING_LENGTH
    end

    def apply_hookes_law
      vector = @target.position - @source.position
      direction = vector.normalize
      displacement = @length - vector.magnitude
      @source.update_accelerate(direction * (- STIFFNESS * displacement))
      @target.update_accelerate(direction * (STIFFNESS * displacement))
    end
  end
end
