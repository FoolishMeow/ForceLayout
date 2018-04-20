require 'json'

module ForceLayout
  autoload :Edge,         'force_layout/edge'
  autoload :Node,         'force_layout/node'
  autoload :Vector,       'force_layout/vector'
  autoload :Point,        'force_layout/point'
  autoload :Spring,       'force_layout/spring'
  autoload :Layer,        'force_layout/layer'
  autoload :Entirety,     'force_layout/entirety'
  autoload :Hierarchy,    'force_layout/hierarchy'

  def self.entirety_layout!(data)
    @thread = Entirety.new
    @thread.import_data data
    @thread.init_nodes_point
    @thread.init_edges_spring
    @thread.tick(@thread.tick_interval)
    energy = @thread.total_energy

    while energy > @thread.energy_threshold
      @thread.tick(@thread.tick_interval)
      @thread.iterations += 1
      energy = @thread.total_energy
    end
  end

  def self.hierarchy_layout!(data)
    @thread = Hierarchy.new
    @thread.import_data data
    @thread.init_nodes_point
    @thread.init_edges_spring
    @thread.tick(@thread.tick_interval)
    energy = @thread.total_energy

    while energy > @thread.energy_threshold
      @thread.tick(@thread.tick_interval)
      @thread.iterations += 1
      energy = @thread.total_energy
    end
  end
end
