module ForceLayout
  class Layer
    attr_reader :type
    attr_accessor :nodes, :edges

    @@layers = []

    def initialize(type)
      @type = type
      @nodes = []
      @edges = []
    end

    def save
      @@layers << self if Layer.find_by(type).nil?
    end

    def self.all
      @@layers
    end

    def self.count
      @@layers.length
    end

    def self.find_by(type)
      @@layers.each do |layer|
        return layer if layer.type == type
      end
      nil
    end

    def self.find_or_create_by(type)
      Layer.new(type).save unless Layer.find_by(type)
      find_by(type)
    end
  end
end
