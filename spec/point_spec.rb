require 'vector'
require 'point'

RSpec.describe Point, 'point' do
  before(:all) do
    position = Vector.new(1, 2, 3)
    @point = Point.new(position, 'id')
  end

  context 'Accelerate' do
    it 'can update its accelerate' do
      force = Vector.new(2, 3, 4)
      accelerate = @point.update_accelerate(force)
      expect(accelerate.x).to eq 2
      expect(accelerate.y).to eq 3
      expect(accelerate.z).to eq 4
    end
  end
end
