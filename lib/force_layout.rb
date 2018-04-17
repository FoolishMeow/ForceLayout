require 'json'
module ForceLayout
  autoload :Edge,         'force_layout/edge'
  autoload :Node,         'force_layout/node'
  autoload :Vector,       'force_layout/vector'
  autoload :Point,        'force_layout/point'
  autoload :Spring,       'force_layout/spring'

  def self.run!(data)
    @thread = ForceLayout.new
    @thread.import_data data
    @thread.init_nodes_points
    @thread.init_edges_spring
    energy = @thread.total_energy

    while energy < @thread.energy_threshold || @thread.iterations == 1_000_000
      @thread.tick(@thread.tick_interval)
      @thread.iterations += 1
      energy = @thread.total_energy
    end
  end

  class ForceLayout
    attr_accessor :energy_threshold, :iterations, :center, :tick_interval
    def initialize
      @energy_threshold = 0.1
      @tick_interval = 0.02
      @iterations = 0
      @center = Vector.new(0, 0, 0)
    end

    def import_data(raw_data)
      data = JSON.parse(raw_data)
      add_nodes(data['nodes'])
      add_edges(data['edges'])
    end

    def add_nodes(nodes_data)
      nodes_data.each do |node_data|
        node = Node.new(node_data)
        node.save if node.id
      end
    end

    def add_edges(edges_data)
      index = 0
      edges_data.each do |edge_data|
        edge = Edge.new(index, edge_data)
        edge.save
        index += 1
      end
    end

    def init_nodes_points
      Node.all.each do |node|
        vector = Vector.new(rand(-10..10), rand(-10..10), rand(-10..10))
        node.point = Point.new(vector, node.id, node.data['group'])
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
