module ForceLayout
  class Entirety < LayoutAlgorithm
    def update_hookes_law
      Edge.all.each do |edge|
        spring = edge.spring
        spring.apply_hookes_law
      end
    end

    def update_coulombs_law
      (0...(Node.count - 1)).each do |i|
        point_i = Node.all[i].point
        ((i + 1)...Node.count).each do |j|
          point_j = Node.all[j].point
          point_i.apply_coulombs_law(point_j)
        end
      end
    end

    def attract_to_center
      Node.all.each do |node|
        point = node.point
        direction = point.position
        point.update_accelerate(direction * - Point::REPULSION / 50.0)
      end
    end
  end
end
