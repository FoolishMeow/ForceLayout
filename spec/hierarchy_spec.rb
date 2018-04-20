require 'spec_helper'

RSpec.describe ForceLayout::Hierarchy, 'hierarchy' do
  before(:all) do
    @file = File.read(File.expand_path('./test_data.json', File.dirname(__FILE__)))
    @data = JSON.parse(@file)
    @hierarchy_layout = ForceLayout::Hierarchy.new
  end

  context 'Parse data to objects' do
    it 'add nodes' do
      @hierarchy_layout.add_nodes(@data['nodes'])
      expect(ForceLayout::Node.count).to eq 4
      expect(ForceLayout::Layer.find_by(1).nodes.length).to eq 3
    end

    it 'add edges' do
      @hierarchy_layout.add_edges(@data['edges'])
      expect(ForceLayout::Edge.count).to eq 3
      expect(ForceLayout::Layer.find_by(1).edges.length).to eq 2
    end
  end

  context 'Add Point and Spring' do
    it 'init nodes point' do
      expect(ForceLayout::Layer.find_by(1).nodes[0].point).to eq nil
      @hierarchy_layout.init_nodes_point
      expect(ForceLayout::Layer.find_by(1).nodes[0].point).not_to eq nil
    end

    it 'init edges spring' do
      expect(ForceLayout::Edge.all[0].spring).to eq nil
      @hierarchy_layout.init_edges_spring
      expect(ForceLayout::Edge.all[0].spring).not_to eq nil
    end
  end

  context 'Update' do
    it 'update coulombs law' do
      origin_accelerate_x = ForceLayout::Layer.all[0].nodes[0].point.accelerate.x
      @hierarchy_layout.update_coulombs_law
      expect(ForceLayout::Layer.all[0].nodes[0].point.accelerate.x).not_to eq origin_accelerate_x
    end

    it 'update hookes law' do
      origin_accelerate_x = ForceLayout::Node.all[0].point.accelerate.x
      @hierarchy_layout.update_hookes_law
      expect(ForceLayout::Node.all[0].point.accelerate.x).not_to eq origin_accelerate_x
    end

    it 'attract to center' do
      origin_accelerate_x = ForceLayout::Node.all[0].point.accelerate.x
      @hierarchy_layout.attract_to_center
      expect(ForceLayout::Node.all[0].point.accelerate.x).not_to eq origin_accelerate_x
    end

    it 'update velocity' do
      origin_velocity_x = ForceLayout::Node.all[0].point.velocity.x
      @hierarchy_layout.update_velocity(0.02)
      expect(ForceLayout::Node.all[0].point.velocity.x).not_to eq origin_velocity_x
    end

    it 'update position' do
      origin_position_x = ForceLayout::Node.all[0].point.position.x
      @hierarchy_layout.update_position(0.02)
      expect(ForceLayout::Node.all[0].point.position.x).not_to eq origin_position_x
    end

    it 'get total energy' do
      expect(@hierarchy_layout.total_energy).not_to eq 0
    end
  end
end
