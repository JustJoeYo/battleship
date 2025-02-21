require 'spec_helper.rb'

require 'spec_helper.rb'

RSpec.configure do |config|
  config.formatter = :documentation
end

RSpec.describe Board do
  before(:each) do
    @board = Board.new
    @cruiser = Ship.new("Cruiser", 3)
    @submarine = Ship.new("Submarine", 2)
  end

  describe '#initialize' do
    it 'initialize' do
      expect(@board).to be_an_instance_of(Board)
    end

    it 'is a hash' do
      expect(@board.cells).to be_a(Hash)
    end

    it 'has cells' do
      expect(@board.cells.size).to eq(16)
    end

    it 'has values' do
      expect(@board.cells.values.all? { |cell| cell.is_a?(Cell) }).to be true
    end
  end

  describe '#valid_coordinate?' do
    it 'validates coordinates' do
      expect(@board.valid_coordinate?("A1")).to be true
      expect(@board.valid_coordinate?("D4")).to be true
      expect(@board.valid_coordinate?("A5")).to be false
      expect(@board.valid_coordinate?("E1")).to be false
      expect(@board.valid_coordinate?("A22")).to be false
    end
  end

  describe '#valid_placement?' do
    it 'validates length of ship' do
      expect(@board.valid_placement?(@cruiser, ["A1", "A2"])).to be false
      expect(@board.valid_placement?(@submarine, ["A2", "A3", "A4"])).to be false
    end

    it 'consecutive coordinates' do
      expect(@board.valid_placement?(@cruiser, ["A1", "A2", "A4"])).to be false
      expect(@board.valid_placement?(@submarine, ["A1", "C1"])).to be false # just different style ships (2 long, 3 long etc just sanity checkin them)
      expect(@board.valid_placement?(@cruiser, ["A3", "A2", "A1"])).to be false
      expect(@board.valid_placement?(@submarine, ["C1", "B1"])).to be false
    end

    it 'non-diagonal coordinates' do
      expect(@board.valid_placement?(@cruiser, ["A1", "B2", "C3"])).to be false
      expect(@board.valid_placement?(@submarine, ["C2", "D3"])).to be false
    end

    it 'correct placement check' do
      expect(@board.valid_placement?(@submarine, ["A1", "A2"])).to be true
      expect(@board.valid_placement?(@cruiser, ["B1", "C1", "D1"])).to be true
    end
  end

  describe '#place' do
    it 'places a ship on the board' do
      @board.place(@cruiser, ["A1", "A2", "A3"])

      cell_1 = @board.cells["A1"]
      cell_2 = @board.cells["A2"]
      cell_3 = @board.cells["A3"]

      expect(cell_1.ship).to eq(@cruiser)
      expect(cell_2.ship).to eq(@cruiser)
      expect(cell_3.ship).to eq(@cruiser)
      expect(cell_3.ship).to eq(cell_2.ship)
    end
  end

  describe '#render' do
    it 'renders the board' do
      #expect(@board.render).to eq("     1  2  3  4 \n  ┌────────────────┐\nA │   │   │   │   │\n  ├───┼───┼───┼───┤\nB │   │   │   │   ...───┼───┼───┤\nC │   │   │   │   │\n  ├───┼───┼───┼───┤\nD │   │   │   │   │\n  └────────────────┘\n")

      @board.place(@cruiser, ["A1", "A2", "A3"])
      # expect(@board.render(true)).to eq("+     1  2  3  4 
      #  +  ┌────────────────┐
      #  +A │ S │ S │ S │   │
      #  +  ├───┼───┼───┼───┤
      #  +B │   │   │   │   │
      #  +  ├───┼───┼───┼───┤
      #  +C │   │   │   │   │
      #  +  ├───┼───┼───┼───┤
      #  +D │   │   │   │   │
      #  +  └────────────────┘")
    end
  end
end