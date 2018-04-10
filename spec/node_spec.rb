require 'node'

RSpec.describe Node, 'node' do
  before(:all) do
    @node1 = Node.new('id': 'Napoleon', 'group': 1)
    @node2 = Node.new('id': 'Myriel', 'group': 1)
  end

  context 'Init Node' do
    it 'can new a node with data' do
      expect(@node1.id).to eq 'Napoleon'
    end
  end

  context 'Save and Search' do
    it 'can save all nodes in Node.all' do
      @node1.save
      @node2.save
      expect(Node.all).to eq [@node1, @node2]
    end

    it 'can find node by id' do
      node = Node.find('Myriel')
      expect(node).to eq @node2
    end
  end
end
