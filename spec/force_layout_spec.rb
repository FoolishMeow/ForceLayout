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
      expect(Node.all.length).to eq 4
    end

    it 'add edges' do
      @force_layout.add_edges(@data['edges'])
      expect(Edge.all.length).to eq 3
    end
  end

  context 'Init position' do
    it 'init point' do
      @force_layout.init_nodes_points
      expect(Node.all[0].point).not_to be_nil
    end

    it 'init spring' do
      @force_layout.init_edges_spring
      expect(Edge.all[0].spring).not_to be_nil
    end
  end
end
