require 'json'

module ForceLayout
  autoload :Edge,         'force_layout/edge'
  autoload :Node,         'force_layout/node'
  autoload :Vector,       'force_layout/vector'
  autoload :Point,        'force_layout/point'
  autoload :Spring,       'force_layout/spring'
  autoload :Entirety,     'force_layout/entirety'

  def self.entirety_layout!(data)
    @thread = Entirety.new
    @thread.import_data data
    @thread.init_nodes_point
    @thread.init_edges_spring
    energy = 10

    while energy > @thread.energy_threshold
      @thread.tick(@thread.tick_interval)
      @thread.iterations += 1
      energy = @thread.total_energy
    end
  end
end
