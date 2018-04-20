require 'spec_helper'

RSpec.describe ForceLayout::Edge, 'edge' do
  before(:all) do
    file = File.read(File.expand_path('./test_data.json', File.dirname(__FILE__)))
    @data = JSON.parse(file)
    nodes_data = @data['nodes']
    edge_data = @data['edges'][0]
    ForceLayout::Node.add_nodes(nodes_data)
    @edge = ForceLayout::Edge.new(0, edge_data)
  end

  context 'Init Edge' do
    it 'can new a edge with data' do
      expect(@edge.source).to eq ForceLayout::Node.all[1]
      expect(@edge.target).to eq ForceLayout::Node.all[0]
    end
  end

  context 'Save and Search' do
    it 'can save all edges in Edge.all' do
      @edge.save
      expect(ForceLayout::Edge.all).to eq [@edge]
    end

    it 'check duplicated?' do
      expect(@edge.duplicated?).to eq true
    end

    it 'can not save edge if edge is duplicated' do
      expect do
        @edge.save
      end.to change { ForceLayout::Edge.count }.by(0)
    end

    it 'can find edge by id' do
      edge = ForceLayout::Edge.find(0)
      expect(edge).to eq @edge
    end
  end

  context 'Add edges with edges_data' do
    it 'transform data to edge objects' do
      ForceLayout::Edge.add_edges(@data['edges'])
      expect(ForceLayout::Edge.count).to eq 3
    end
  end

  context 'Layer' do
    it 'check if in a layer' do
      expect(@edge.in_same_layer?).to eq true
      edge_2 = ForceLayout::Edge.new(1, @data['edges'][1])
      expect(edge_2.in_same_layer?).to eq false
    end

    it 'return edges that in the same layer' do
      expect(ForceLayout::Edge.in_same_layer.length).to eq 2
    end

    it 'return edges that cross different layers' do
      expect(ForceLayout::Edge.cross_layers.length).to eq 1
    end
  end
end
