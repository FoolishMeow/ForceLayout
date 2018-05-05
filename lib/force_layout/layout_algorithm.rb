module ForceLayout
  class LayoutAlgorithm
    attr_accessor :energy_threshold, :tick_interval, :iterations

    def self.exec!(data)
      @thread = self.new
      @thread.import_data data
      @thread.init_nodes_point
      @thread.init_edges_spring
      @thread.tick(@thread.tick_interval)
      energy = @thread.total_energy

      timer = 0
      while energy > @thread.energy_threshold
        @thread.tick(@thread.tick_interval)
        @thread.iterations += 1
        energy = @thread.total_energy
        if ForceLayout.settings.debug
          if (timer += 1) > ForceLayout::DEBUG_INTERVAL
            puts "Now Energy: #{energy}, target: #{ForceLayout.settings.energy_threshold}"
            timer = 0
          end
        end
      end
    end

    def initialize
      @energy_threshold = ForceLayout.settings[:energy_threshold]
      @tick_interval = ForceLayout.settings[:tick_interval]
      @iterations = ForceLayout.settings[:iterations]
    end

    def import_data(data)
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
      raise "Need Redefine for #{self.class}"
    end

    def update_hookes_law
      raise "Need Redefine for #{self.class}"
    end

    def attract_to_center
      raise "Need Redefine for #{self.class}"
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