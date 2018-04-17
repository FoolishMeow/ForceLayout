require 'spec_helper'

RSpec.describe ForceLayout::Vector, 'vector' do
  before(:all) do
    @vector1 = ForceLayout::Vector.new(1, 2, 3)
    @vector2 = ForceLayout::Vector.new(2, 3, 4)
    @vector3 = ForceLayout::Vector.new(1, 2, 2)
  end

  context 'Bsic operation' do
    it 'can plus' do
      vector = @vector1 + @vector2
      expect(vector.x).to eq 3
      expect(vector.y).to eq 5
      expect(vector.z).to eq 7
    end

    it 'can minus' do
      vector = @vector2 - @vector1
      expect(vector.x).to eq 1
      expect(vector.y).to eq 1
      expect(vector.z).to eq 1
    end

    it 'can minus' do
      vector = @vector2 - @vector1
      expect(vector.x).to eq 1
      expect(vector.y).to eq 1
      expect(vector.z).to eq 1
    end

    it 'can multiply' do
      vector = @vector1 * 2
      expect(vector.x).to eq 2
      expect(vector.y).to eq 4
      expect(vector.z).to eq 6
    end

    it 'can divide' do
      vector = @vector1 / 2.0
      expect(vector.x).to eq 0.5
      expect(vector.y).to eq 1
      expect(vector.z).to eq 1.5
    end

    it 'can get the length of the vector' do
      length = @vector3.magnitude
      expect(length).to eq 3
    end

    it 'can get unit direction vector' do
      normal = @vector3.normalize
      expect(normal.x).to eq 0.3333333333333333
      expect(normal.y).to eq 0.6666666666666666
      expect(normal.z).to eq 0.6666666666666666
    end
  end
end
