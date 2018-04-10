class Point
  attr_reader :position, :id, :type, :mass

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
