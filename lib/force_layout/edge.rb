module ForceLayout
  class Edge
    attr_reader :id, :source, :target, :data
    attr_accessor :spring

    @@edges = []

    def initialize(id, data)
      @id = id
      @source = Node.find(data['source'])
      @target = Node.find(data['target'])
      @data = data
      @spring = nil
    end

    def save
      @@edges << self unless duplicated?
    end

    def duplicated?
      @@edges.each do |edge|
        return true if edge.source == source && edge.target == target
      end
      false
    end

    def in_same_layer?
      source.data['type'] == target.data['type']
    end

    def self.in_same_layer
      @@edges.select(&:in_same_layer?)
    end

    def self.cross_layers
      @@edges - Edge.in_same_layer
    end

    def self.add_edges(edges_data)
      index = 0
      edges_data.each do |edge_data|
        edge = Edge.new(index, edge_data)
        index += 1 if edge.save
      end
    end

    def self.all
      @@edges
    end

    def self.find(id)
      @@edges.each do |edge|
        return edge if edge.id == id
      end
    end

    def self.count
      @@edges.length
    end
  end
end
