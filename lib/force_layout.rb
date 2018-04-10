require 'force_layout/version'
require 'json'

class ForceLayout
  def initialize
    @props = {
      energy_threshold: 0.1,
      tick_interval: 0.02
    }
    @iterations = 0
    @render_time = 0
    @center = Vector.new(0, 0, 0)
  end

  def import_data
    file = File.read('data.json')
    data = JSON.parse(file)
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
      vector = Vector.new(rand(20), rand(20), rand(20))
      node.point = Point.new(vector, node.id, node.data['group'])
    end
  end

  def init_edges_spring
    Edge.all.each do |edge|
      source = edge.source
      target = edge.target
      length = Spring::DEFAULT_SPRING_LENGTH
      edge.spring = Spring.new(source, target, length)
    end
  end
end
