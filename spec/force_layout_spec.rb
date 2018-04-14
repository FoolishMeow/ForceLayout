require 'json'
require 'vector'
require 'node'
require 'edge'
require 'point'
require 'spring'
require 'force_layout'

RSpec.describe ForceLayout, 'force_layout' do
  before(:all) do
    file = File.read(File.expand_path('./test_data.json', File.dirname(__FILE__)))
    @data = JSON.parse(file)
    @force_layout = ForceLayout.new
  end

  context 'Parse data to Object' do
    it 'add nodes' do
      @force_layout.add_nodes(@data['nodes'])
      expect(Node.count).to eq 4
    end

    it 'add edges' do
      @force_layout.add_edges(@data['edges'])
      expect(Edge.count).to eq 3
    end
  end

  context 'Init position' do
    it 'init point' do
      expect(Node.all[0].point).to be_nil
      @force_layout.init_nodes_points
      expect(Node.all[0].point).not_to be_nil
    end

    it 'init spring' do
      expect(Edge.all[0].spring).to be_nil
      @force_layout.init_edges_spring
      expect(Edge.all[0].spring).not_to be_nil
    end
  end

  context 'Update' do
    it 'update coulombs law' do
      expect(Node.all[0].point.accelerate.x).to eq 0
      @force_layout.update_coulombs_law
      expect(Node.all[0].point.accelerate.x).not_to eq 0
    end

    it 'update hookes law' do
      origin_accelerate_x = Node.all[0].point.accelerate.x
      @force_layout.update_hookes_law
      expect(Node.all[0].point.accelerate.x).not_to eq origin_accelerate_x
    end

    it 'attract to center' do
      origin_accelerate_x = Node.all[0].point.accelerate.x
      @force_layout.attract_to_center
      expect(Node.all[0].point.accelerate.x).not_to eq origin_accelerate_x
    end

    it 'update velocity' do
      @force_layout.update_velocity(0.02)
      expect(Node.all[0].point.accelerate.x).to eq 0
      expect(Node.all[0].point.velocity.x).not_to eq 0
    end

    it 'update position' do
      origin_position_x = Node.all[0].point.position.x
      @force_layout.update_position(0.02)
      expect(Node.all[0].point.position.x).not_to eq origin_position_x
    end

    it 'get totle energy' do
      expect(@force_layout.total_energy).not_to eq 0
    end
  end
end
