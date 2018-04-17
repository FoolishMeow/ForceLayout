module ForceLayout
  class Point
    attr_reader :id, :type, :mass
    attr_accessor :velocity, :accelerate, :position

    REPULSION = 200.0
    DAMPING = 0.8
    MAX_SPEED = 1000
    COULOM_DIS_SCALE = 0.01

    def initialize(position, id, type = -1, mass = 1.0)
      @position = position
      @mass = mass
      @velocity = Vector.new(0, 0, 0)
      @accelerate = Vector.new(0, 0, 0)
      @id = id
      @type = type
    end

    def update_accelerate(force)
      @accelerate += force / mass
    end
  end
end
