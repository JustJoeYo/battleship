require 'spec_helper.rb'

RSpec.configure do |config|
  config.formatter = :documentation
end

RSpec.describe Board do
  before(:each) do
    @board = Board.new
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

  describe '#valid_coordinate?' do # should i be making a def for each and everything?
  # or just initialize? I am unsure of the standard practice.
    it 'validates coordinates' do
      expect(@board.valid_coordinate?("A1")).to be true
      expect(@board.valid_coordinate?("D4")).to be true
      expect(@board.valid_coordinate?("A5")).to be false
      expect(@board.valid_coordinate?("E1")).to be false
      expect(@board.valid_coordinate?("A22")).to be false
    end
  end
end