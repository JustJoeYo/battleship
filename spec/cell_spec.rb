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

  it 'knows when it has been fired upon and damages the ship' do
    cell = Cell.new("B4")
    cruiser = Ship.new("Cruiser", 3)
    cell.place_ship(cruiser)

    expect(cell.fired_upon?).to be false

    cell.fire_upon

    expect(cell.ship.health).to eq(2)
    expect(cell.fired_upon?).to be true
  end

  it 'renders correctly' do # similar to can render but interaction pattern specific.
    cell_1 = Cell.new("B4")
    expect(cell_1.render).to eq(".")

    cell_1.fire_upon
    expect(cell_1.render).to eq("M")

    cell_2 = Cell.new("C3")
    cruiser = Ship.new("Cruiser", 3)
    cell_2.place_ship(cruiser)
    expect(cell_2.render).to eq(".")
    expect(cell_2.render(true)).to eq("S") # show users own ship

    cell_2.fire_upon
    expect(cell_2.render).to eq("H")

    cruiser.hit
    cruiser.hit
    expect(cruiser.sunk?).to be true
    expect(cell_2.render).to eq("X")
  end
end