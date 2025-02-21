require './lib/ship'

RSpec.configure do |config|
  config.formatter = :documentation
end

RSpec.describe Ship do
  before(:each) do
    @cruiser = Ship.new("Cruiser", 3)
  end

  describe '#initialize' do
    it 'initialize' do
      expect(@cruiser).to be_an_instance_of(Ship)
    end
  
    it 'has a name' do
      expect(@cruiser.name).to eq("Cruiser")
    end
  
    it 'has a length' do
      expect(@cruiser.length).to eq(3)
    end
  
    it 'has health' do
      expect(@cruiser.health).to eq(3)
    end

    it 'not sunk' do
      expect(@cruiser.sunk?).to be false
    end
  end

  describe '#ship_health' do
    it 'can be hit' do
      @cruiser.hit
      expect(@cruiser.health).to eq(2)

      @cruiser.hit
      expect(@cruiser.health).to eq(1)
    end

    it 'can be sunk' do
      @cruiser.hit
      @cruiser.hit
      @cruiser.hit

      expect(@cruiser.sunk?).to be true
    end
  end
end