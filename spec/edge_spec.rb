require 'node'
require 'edge'

RSpec.describe Edge, 'edge' do
  before(:all) do
    @node1 = Node.new('id': 'Napoleon', 'group': 1)
    @node2 = Node.new('id': 'Myriel', 'group': 1)
    @node1.save
    @node2.save
    edge_data = { 'source': 'Napoleon', 'target': 'Myriel', 'value': 1 }
    @edge = Edge.new(1, edge_data)
  end

  context 'Init Edge' do
    it 'can new a edge with data' do
      expect(@edge.source).to eq @node1
      expect(@edge.target).to eq @node2
    end
  end

  context 'Save and Search' do
    it 'can save all edges in Edge.all' do
      @edge.save
      expect(Edge.all).to eq [@edge]
    end

    it 'can find edge by id' do
      edge = Edge.find(1)
      expect(edge).to eq @edge
    end
  end
end
