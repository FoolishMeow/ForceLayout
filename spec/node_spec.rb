require 'node'

RSpec.describe Node, 'node' do
  before(:all) do
    data = { 'id': 'Myriel', 'group': 1 }
    @node = Node.new(data)
  end

  context 'Init Node' do
    it 'can new a node with data' do
      expect(@node.id).to eq 'Myriel'
    end
  end

  context 'Save and Search' do
    it 'can save all nodes in Node.all' do
      @node.save
      expect(Node.all).to eq [@node]
    end

    it 'can find node by id' do
      node = Node.find('Myriel')
      expect(node).to eq @node
    end
  end
end
