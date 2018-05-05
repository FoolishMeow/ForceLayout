module ForceLayout
  class Hierarchy
    attr_accessor :energy_threshold, :tick_interval, :iterations

    def initialize
      @energy_threshold = ForceLayout.settings[:energy_threshold]
      @tick_interval = ForceLayout.settings[:tick_interval]
      @iterations = ForceLayout.settings[:iterations]
    end

    def import_data(data)
      add_nodes(data['nodes'])
      add_edges(data['edges'])
    end

    def add_nodes(nodes_data)
      Node.add_nodes(nodes_data)
      Node.all.each do |node|
        layer = Layer.find_or_create_by(node.data['type'])
        layer.nodes << node
      end
    end

    def add_edges(edges_data)
      Edge.add_edges(edges_data)
      Edge.all.each do |edge|
        if edge.in_same_layer?
          layer = Layer.find_or_create_by(edge.source.data['type'])
          layer.edges << edge
        end
      end
    end

    def init_nodes_point
      index = 0
      Layer.all.each do |layer|
        layer.nodes.each do |node|
          vector = Vector.new(rand(-10..10), rand(-10..10), index)
          vector = Vector.new(rand(-10..10), rand(-10..10), index) while vector.duplicated_in_xy?
          vector.save
          node.point = Point.new(vector, node.id, node.data['type'])
        end
        index += 5
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

    def update_hookes_law
      Edge.in_same_layer.each do |edge|
        spring = edge.spring
        spring.apply_hookes_law
      end
      Edge.cross_layers.each do |edge|
        spring = edge.spring
        vector = spring.target.position - spring.source.position
        displacement = 5 - vector.magnitude
        force = Spring::STIFFNESS * displacement
        target_on_layer = Vector.new(spring.target.position.x, spring.target.position.y, spring.source.position.z)
        vector_on_layer = (target_on_layer - spring.source.position)
        force_on_layer = force * (vector_on_layer.magnitude / vector.magnitude)

        spring.source.update_accelerate(vector_on_layer.normalize * force_on_layer * -1)
        spring.target.update_accelerate(vector_on_layer.normalize * force_on_layer)
      end
    end

    def update_coulombs_law
      Layer.all.each do |layer|
        (0...(layer.nodes.length - 1)).each do |i|
          point_i = layer.nodes[i].point
          ((i + 1)...layer.nodes.length).each do |j|
            point_j = layer.nodes[j].point
            point_i.apply_coulombs_law(point_j)
          end
        end
      end
    end

    def attract_to_center
      Node.all.each do |node|
        point = node.point
        direction = Vector.new(node.point.position.x, node.point.position.y, 0)
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
