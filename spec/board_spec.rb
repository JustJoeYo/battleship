require 'spec_helper'

RSpec.configure do |config|
  config.formatter = :documentation
end

RSpec.describe Board do
  before(:each) do
    @board = Board.new # => #<Board:0x00007ff0728c8010...>
    @cruiser = Ship.new("Cruiser", 3) # => #<Ship:0x00007fcb0d989510...>
    @submarine = Ship.new("Submarine", 2) # => #<Ship:0x00007fcb0e8402c0...>
  end

  describe '#initialize' do
    it 'initialize' do
      expect(@board).to be_an_instance_of(Board) # => true
    end

    it 'is a hash' do
      expect(@board.cells).to be_a(Hash) # => true
    end

    it 'has cells' do
      expect(@board.cells.size).to eq(16) # => 16
    end

    it 'has values' do
      expect(@board.cells.values.all? { |cell| cell.is_a?(Cell) }).to be true # => true
    end
  end

  describe '#valid_coordinate?' do
    it 'validates coordinates' do
      expect(@board.valid_coordinate?("A1")).to be true # => true
      expect(@board.valid_coordinate?("D4")).to be true # => true
      expect(@board.valid_coordinate?("A5")).to be false # => false
      expect(@board.valid_coordinate?("E1")).to be false # => false
      expect(@board.valid_coordinate?("A22")).to be false # => false
    end
  end

  describe '#valid_placement?' do
    it 'validates length of ship' do
      expect(@board.valid_placement?(@cruiser, ["A1", "A2"])).to be false # => false
      expect(@board.valid_placement?(@submarine, ["A2", "A3", "A4"])).to be false # => false
    end

    it 'consecutive coordinates' do
      expect(@board.valid_placement?(@cruiser, ["A1", "A2", "A4"])).to be false # => false
      expect(@board.valid_placement?(@submarine, ["A1", "C1"])).to be false # => false
      expect(@board.valid_placement?(@cruiser, ["A3", "A2", "A1"])).to be false # => false
      expect(@board.valid_placement?(@submarine, ["C1", "B1"])).to be false # => false
    end

    it 'non-diagonal coordinates' do
      expect(@board.valid_placement?(@cruiser, ["A1", "B2", "C3"])).to be false # => false
      expect(@board.valid_placement?(@submarine, ["C2", "D3"])).to be false # => false
    end

    it 'correct placement check' do
      expect(@board.valid_placement?(@submarine, ["A1", "A2"])).to be true # => true
      expect(@board.valid_placement?(@cruiser, ["B1", "C1", "D1"])).to be true # => true
    end
  end

  describe '#place' do
    it 'places a ship on the board' do
      @board.place(@cruiser, ["A1", "A2", "A3"])

      cell_1 = @board.cells["A1"]
      cell_2 = @board.cells["A2"]
      cell_3 = @board.cells["A3"]

      expect(cell_1.ship).to eq(@cruiser) # => #<Ship:0x00007fcb0d989510...>
      expect(cell_2.ship).to eq(@cruiser) # => #<Ship:0x00007fcb0d989510...>
      expect(cell_3.ship).to eq(@cruiser) # => #<Ship:0x00007fcb0d989510...>
      expect(cell_3.ship).to eq(cell_2.ship) # => true
    end
  end

  describe '#render' do
    it 'renders the board' do
      # using expected_output to keep it slightly organized
      expected_output = "     1  2  3  4 \n  ┌────────────────┐\nA │   │   │   │   │\n  ├───┼───┼───┼───┤\nB │   │   │   │   │\n  ├───┼───┼───┼───┤\nC │   │   │   │   │\n  ├───┼───┼───┼───┤\nD │   │   │   │   │\n  └────────────────┘\n"
      expect(@board.render.gsub(/\s+/, '')).to eq(expected_output.gsub(/\s+/, '')) # => true
      @board.place(@cruiser, ["A1", "A2", "A3"])
      # using gsub to remove spaces ".gsub(/\s+/, '')" we can check the output
      # is the same or not without worrying about the minor formatting differences.
      expected_output_2 = "     1  2  3  4 \n  ┌────────────────┐\nA │ \e[32mS\e[0m │ \e[32mS\e[0m │ \e[32mS\e[0m │   │\n  ├───┼───┼───┼───┤\nB │   │   │   │   │\n  ├───┼───┼───┼───┤\nC │   │   │   │   │\n  ├───┼───┼───┼───┤\nD │   │   │   │   │\n  └────────────────┘\n"
      expect(@board.render(true).gsub(/\s+/, '')).to eq(expected_output_2.gsub(/\s+/, '')) # => true
    end
  end
end