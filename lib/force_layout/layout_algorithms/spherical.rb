module ForceLayout
  class Spherical < LayoutAlgorithm
    def update_coulombs_law
      (0...(Node.count - 1)).each do |i|
        point_i = Node.all[i].point
        ((i + 1)...Node.count).each do |j|
          point_j = Node.all[j].point
          point_i.apply_coulombs_law(point_j)
        end
      end
    end

    def update_hookes_law
      Edge.all.each do |edge|
        spring = edge.spring
        spring.apply_hookes_law
      end
    end

    def attract_to_center
      center = Vector.new(0, 0, 0)
      center_point = Point.new(center, 'center')
      Node.all.each do |node|
        point = node.point
        vector = node.point.position
        direction = vector.normalize
        displacement = 20 - vector.magnitude
        node.point.update_accelerate(direction * (2000 * displacement))
      end
    end
  end
end
