class Node
  attr_reader :id, :data

  @@nodes = []

  def initialize(data)
    @id = data[:id]
    @data = data
  end

  def save
    @@nodes << self if Node.find(id).nil?
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
end
