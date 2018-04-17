require 'spec_helper'

RSpec.describe ForceLayout::Node, 'node' do
  before(:all) do
    file = File.read(File.expand_path('./test_data.json', File.dirname(__FILE__)))
    data = JSON.parse(file)
    node_data = data['nodes'][0]
    @node = ForceLayout::Node.new(node_data)
  end

  context 'Init Node' do
    it 'can new a node with data' do
      expect(@node.id).to eq 'Myriel'
    end
  end

  context 'Save and Search' do
    it 'can save all nodes in Node.all' do
      @node.save
      expect(ForceLayout::Node.all).to eq [@node]
    end

    it 'can find node by id' do
      node = ForceLayout::Node.find('Myriel')
      expect(node).to eq @node
    end

    it 'count' do
      expect(ForceLayout::Node.count).to eq 1
    end
  end
end
