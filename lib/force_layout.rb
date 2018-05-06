require_relative "force_layout/version"
require_relative "force_layout/layout_algorithm"
require 'json'

module ForceLayout
  autoload :Edge,         'force_layout/edge'
  autoload :Node,         'force_layout/node'
  autoload :Vector,       'force_layout/vector'
  autoload :Point,        'force_layout/point'
  autoload :Spring,       'force_layout/spring'
  autoload :Layer,        'force_layout/layer'
  autoload :Entirety,     'force_layout/layout_algorithms/entirety'
  autoload :Hierarchy,    'force_layout/layout_algorithms/hierarchy'
  autoload :Spherical,    'force_layout/layout_algorithms/spherical'

  @@settings = {
    energy_threshold: 1,
    tick_interval: 0.02,
    iterations: 0,
    debug: true,
    debug_interval: 10,
    layer_height: 10
  }

  class << self
    def settings
      @@settings
    end

    def set(key, value)
      @@settings[key] = value
    end

    def entirety_layout!(data)
      Entirety.exec! data
    end

    def hierarchy_layout!(data)
      Hierarchy.exec! data
    end

    def spherical_layout!(data)
      Spherical.exec! data
    end
  end
end
