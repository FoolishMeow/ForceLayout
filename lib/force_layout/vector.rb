module ForceLayout
  class Vector
    attr_reader :x, :y, :z

    @@vectors = []

    def initialize(x, y, z)
      @x, @y, @z = x, y, z
    end

    def +(other)
      x = @x + other.x
      y = @y + other.y
      z = @z + other.z
      Vector.new(x, y, z)
    end

    def -(other)
      x = @x - other.x
      y = @y - other.y
      z = @z - other.z
      Vector.new(x, y, z)
    end

    def *(other)
      x = @x * other
      y = @y * other
      z = @z * other
      Vector.new(x, y, z)
    end

    def /(other)
      x = @x / other
      y = @y / other
      z = @z / other
      Vector.new(x, y, z)
    end

    def magnitude
      Math.sqrt(@x * @x + @y * @y + @z * @z)
    end

    def normalize
      self / magnitude
    end

    def save
      @@vectors << self unless duplicated?
    end

    def duplicated?
      @@vectors.each do |vector|
        return true if vector.x == x && vector.y == y && vector.z == z
      end
      false
    end

    def duplicated_in_xy?
      @@vectors.each do |vector|
        return true if vector.x == x && vector.y == y
      end
      false
    end
  end
end
