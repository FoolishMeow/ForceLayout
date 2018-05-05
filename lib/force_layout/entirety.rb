module ForceLayout
  class Entirety
    attr_accessor :energy_threshold, :iterations
    attr_reader :tick_interval

    def initialize
      @energy_threshold = ForceLayout.settings[:energy_threshold]
      @tick_interval = ForceLayout.settings[:tick_interval]
      @iterations = ForceLayout.settings[:iterations]
    end

    def import_data(raw_data)
      data = JSON.parse(raw_data)
      Node.add_nodes(data['nodes'])
      Edge.add_edges(data['edges'])
    end

    def init_nodes_point
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
      (0...(Node.count - 1)).each do |i|
        point_i = Node.all[i].point
        ((i + 1)...Node.count).each do |j|
          point_j = Node.all[j].point
          point_i.apply_coulombs_law(point_j)
        end
      end
    end

    def update_hookes_law
      Edge.all.each do |edge|
        spring = edge.spring
        spring.apply_hookes_law
      end
    end

    def attract_to_center
      Node.all.each do |node|
        point = node.point
        direction = point.position
        point.update_accelerate(direction * - Point::REPULSION / 50.0)
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
