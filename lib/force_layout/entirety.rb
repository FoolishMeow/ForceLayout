module ForceLayout
  class Entirety
    attr_accessor :energy_threshold, :iterations, :center, :tick_interval

    def initialize
      @energy_threshold = 0.1
      @tick_interval = 0.02
      @iterations = 0
      @center = Vector.new(0, 0, 0)
    end

    def import_data(raw_data)
      data = JSON.parse(raw_data)
      Node.add_nodes(data['nodes'])
      Edge.add_edges(data['edges'])
    end

    def init_nodes_points
      Node.all.each do |node|
        vector = Vector.new(rand(-10..10), rand(-10..10), rand(-10..10))
        vector = Vector.new(rand(-10..10), rand(-10..10), rand(-10..10)) while vector.duplicated?
        vector.save
        node.point = Point.new(vector, node.id, node.data['type'])
      end
    end

    def init_edges_spring
      Edge.all.each do |edge|
        source = edge.source.point
        target = edge.target.point
        length = Spring::DEFAULT_SPRING_LENGTH
        edge.spring = Spring.new(source, target, length)
      end
    end

    def tick(interval)
      update_coulombs_law
      update_hookes_law
      attract_to_center
      update_velocity(interval)
      update_position(interval)
    end

    def update_coulombs_law
      (0...Node.count).each do |i|
        ((i + 1)...Node.count).each do |j|
          node_i = Node.all[i]
          node_j = Node.all[j]
          vector = node_i.point.position - node_j.point.position
          distance = (vector.magnitude + 0.1) * Point::COULOM_DIS_SCALE
          direction = vector.normalize
          node_i.point.update_accelerate(direction * Point::REPULSION / (distance * distance))
          node_j.point.update_accelerate(direction * Point::REPULSION / (distance * distance) * -1)
        end
      end
    end

    def update_hookes_law
      (0...Edge.count).each do |i|
        spring = Edge.all[i].spring
        vector = spring.target.position - spring.source.position
        direction = vector.normalize
        displacement = spring.length - vector.magnitude
        spring.source.update_accelerate(direction * (- Spring::STIFFNESS * displacement))
        spring.target.update_accelerate(direction * (Spring::STIFFNESS * displacement))
      end
    end

    def attract_to_center
      Node.all.each do |node|
        point = node.point
        direction = point.position
        point.update_accelerate(direction * - Point::REPULSION / 100.0)
      end
    end

    def update_velocity(interval)
      Node.all.each do |node|
        point = node.point
        point.velocity += point.accelerate * interval * Point::DAMPING
        if point.velocity.magnitude > Point::MAX_SPEED
          point.velocity = point.velocity.normalize * Point::MAX_SPEED
        end
        point.accelerate = Vector.new(0, 0, 0)
      end
    end

    def update_position(interval)
      Node.all.each do |node|
        point = node.point
        point.position += point.velocity * interval
      end
    end

    def total_energy
      energy = 0.0
      Node.all.each do |node|
        point = node.point
        speed = point.velocity.magnitude
        energy += 0.5 * point.mass * speed * speed
        node.point.velocity = Vector.new(0, 0, 0)
      end
      energy
    end
  end
end
