require 'spec_helper'

RSpec.configure do |config|
  config.formatter = :documentation
end

RSpec.describe Shoot do
  before(:each) do
    @shoot = Shoot.new
    @player = Player.new(4, 4)
    @computer = Player.new(4, 4)
    @player.add_ship("Cruiser", 3)
    @player.board.place(@player.ships.first, ["A1", "A2", "A3"])
  end

  describe '#initialization' do
    it 'initialize' do
      expect(@shoot.last_hit).to be_nil
    end
  end

  describe '#computer_shot' do
    it 'take a shot' do
      allow(@shoot).to receive(:intelligent_guess).and_return("A1")
      expect { @shoot.computer_shot(@computer, @player, 'easy', nil) }.to output(/My shot on A1 was a hit./).to_stdout
      expect(@player.board.cells["A1"].fired_upon?).to be true
    end
  end

  describe '#intelligent_guess' do
    it 'random guess for easy difficulty' do
      allow(@shoot).to receive(:random_guess).and_return("A1")
      expect(@shoot.intelligent_guess(@player, 'easy', nil)).to eq("A1")
    end

    it 'adjacent coordinate for medium difficulty' do
      allow(@shoot).to receive(:adjacent_coordinates).and_return(["A2"])
      expect(@shoot.intelligent_guess(@player, 'medium', "A1")).to eq("A2")
    end

    it 'pattern guess for hard difficulty' do
      allow(@shoot).to receive(:pattern_guess).and_return("A1")
      expect(@shoot.intelligent_guess(@player, 'hard', nil)).to eq("A1")
    end

    describe '#pattern_guess' do
      it 'returns a coordinate based on a pattern' do
        allow(@shoot).to receive(:random_guess).and_return("A1")
        expect(@shoot.pattern_guess(@player)).to eq("A1")
      end
    end

    describe '#adjacent_coordinates' do
      it 'returns adjacent coordinates' do
        expect(@shoot.adjacent_coordinates(@player, "B2")).to contain_exactly("A2", "C2", "B1", "B3")
      end
    end

    describe '#random_guess' do
      it 'returns a random coordinate' do
        expect(@player.board.cells.keys).to include(@shoot.random_guess(@player))
      end
    end
  end

  describe '#valid_coordinate?' do
    it 'validates a coordinate' do
      expect(@shoot.valid_coordinate?(@player, "A1")).to be true
      expect(@shoot.valid_coordinate?(@player, "E1")).to be false
    end
  end
end

# didnt bother making test file for this previously due to most methods deriving from previously tested things