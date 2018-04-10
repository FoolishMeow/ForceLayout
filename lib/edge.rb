class Edge
  attr_reader :id, :source, :target, :data

  @@edges = []

  def initialize(id, data)
    @id = id
    @source = Node.find(data[:source])
    @target = Node.find(data[:target])
    @data = data
  end

  def save
    @@edges << self unless @source.nil? || @target.nil?
  end

  def self.all
    @@edges
  end

  def self.find(id)
    @@edges.each do |edge|
      return edge if edge.id == id
    end
  end
end
