require 'spec_helper'

RSpec.describe ForceLayout::Edge, 'edge' do
  before(:all) do
    file = File.read(File.expand_path('./test_data.json', File.dirname(__FILE__)))
    data = JSON.parse(file)
    nodes_data = data['nodes']
    edge_data = data['edges'][0]
    @node1 = ForceLayout::Node.new(nodes_data[0])
    @node2 = ForceLayout::Node.new(nodes_data[1])
    @node1.save
    @node2.save
    @edge = ForceLayout::Edge.new(1, edge_data)
  end

  context 'Init Edge' do
    it 'can new a edge with data' do
      expect(@edge.source).to eq @node2
      expect(@edge.target).to eq @node1
    end
  end

  context 'Save and Search' do
    it 'can save all edges in Edge.all' do
      @edge.save
      expect(ForceLayout::Edge.all).to eq [@edge]
    end

    it 'can find edge by id' do
      edge = ForceLayout::Edge.find(1)
      expect(edge).to eq @edge
    end

    it 'count' do
      expect(ForceLayout::Edge.count).to eq 1
    end
  end
end
