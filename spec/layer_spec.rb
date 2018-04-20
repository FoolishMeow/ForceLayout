require 'spec_helper'

RSpec.describe ForceLayout::Layer, 'layer' do
  before(:all) do
    @layer = ForceLayout::Layer.new('Method')
  end

  context 'Save and Search' do
    it 'save' do
      @layer.save
      expect(ForceLayout::Layer.all).to eq [@layer]
    end

    it 'find by type' do
      expect(ForceLayout::Layer.find_by('Method')).to eq @layer
      expect(ForceLayout::Layer.find_by('Model')).to eq nil
    end

    it 'find or create by type' do
      layer_1 = ForceLayout::Layer.find_or_create_by('Method')
      layer_2 = ForceLayout::Layer.find_or_create_by('Model')
      expect(layer_1).to eq @layer
      expect(layer_2).to eq ForceLayout::Layer.find_by('Model')
    end
  end
end
