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
end
