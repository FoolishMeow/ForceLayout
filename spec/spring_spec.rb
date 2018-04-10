require 'spring'
require 'vector'
require 'point'

RSpec.describe Spring, 'spring' do
  before(:all) do
    position1 = Vector.new(1, 2, 3)
    @point1 = Point.new(position1, id: 'point1')
    position2 = Vector.new(2, 3, 4)
    @point2 = Point.new(position2, id: 'point2')
  end

  context 'Init spring' do
    it 'save ts length and two point info' do
      spring = Spring.new(@point1, @point2, 3)
      expect(spring.source).to eq @point1
      expect(spring.target).to eq @point2
      expect(spring.length).to eq 3
    end
  end
end
