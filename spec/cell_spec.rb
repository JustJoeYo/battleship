require 'spec_helper.rb'

RSpec.configure do |config|
  config.formatter = :documentation
end

RSpec.describe Cell do
  before(:each) do
    @cell = Cell.new("B4")
    @cruiser = Ship.new("Cruiser", 3)
  end

  describe '#initialize' do
    it 'initialize' do
      expect(@cell).to be_an_instance_of(Cell)
    end

    it 'has a coordinate' do
      expect(@cell.coordinate).to eq("B4")
    end

    it 'has no ship' do
      expect(@cell.ship).to be_nil # cool i havent used this before
    end
  end

  it 'can be empty' do
    expect(@cell.empty?).to be true
  end

  it 'can place a ship' do
    @cell.place_ship(@cruiser)
    expect(@cell.ship).to eq(@cruiser)
    expect(@cell.empty?).to be false
  end

  it 'can be fired upon' do
    @cell.place_ship(@cruiser)
    expect(@cell.fired_upon?).to be false

    @cell.fire_upon
    expect(@cell.ship.health).to eq(2) # dont need this as I already am testing it but just in case
    expect(@cell.fired_upon?).to be true
  end

  it 'can render' do
    expect(@cell.render).to eq(".")

    @cell.fire_upon
    expect(@cell.render).to eq("M")

    @cell = Cell.new("B4") # reset cell (was giving errors without this line as it expected "." and got "H")
    @cell.place_ship(@cruiser)
    expect(@cell.render).to eq(".")
    expect(@cell.render(true)).to eq("S")

    @cell.fire_upon
    expect(@cell.render).to eq("H")

    2.times { @cruiser.hit }
    expect(@cell.render).to eq("X")
  end
end