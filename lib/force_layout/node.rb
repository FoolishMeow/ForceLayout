module ForceLayout
  class Node
    attr_reader :id, :data
    attr_accessor :point

    @@nodes = []

    def initialize(data)
      @id = data['id']
      @data = data
      @point = nil
    end

    def save
      @@nodes << self if Node.find(id).nil?
    end

    def self.add_nodes(nodes_data)
      nodes_data.each do |node_data|
        node = Node.new(node_data)
        node.save
      end
    end

    def self.all
      @@nodes
    end

    def self.find(id)
      @@nodes.each do |node|
        return node if node.id == id
      end
      nil
    end

    def self.count
      @@nodes.length
    end
  end
end
