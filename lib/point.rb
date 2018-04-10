class Point
  attr_reader :position, :id, :group, :mass

  REPULSION = 200.0
  DAMPING = 0.8
  MAX_SPEED = 1000
  COULOM_CONSTANT = 0.01

  def initialize(position, id, group = -1, mass = 1.0)
    @position = position
    @mass = mass
    @velocity = Vector.new(0, 0, 0)
    @accelerate = Vector.new(0, 0, 0)
    @id = id
    @group = group
  end

  def update_accelerate(force)
    @accelerate += force / mass
  end
end
