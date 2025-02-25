require 'spec_helper'

# now in this file we are just testing using the methods together so the tests will be longer

RSpec.configure do |config|
  config.formatter = :documentation
end

RSpec.describe Player do
  before(:each) do
    @player = Player.new(4, 4)
  end

  describe "#initialize" do
    it "initializes" do
      expect(@player).to be_instance_of(Player)
    end

    it 'has a board' do
      expect(@player.board).to be_instance_of(Board)
    end
  end

  it 'can add ships' do
    @player.add_ship("Cruiser", 3)
    expect(@player.ships.length).to eq(1)
    expect(@player.ships.first.name).to eq("Cruiser")
    expect(@player.ships.first.length).to eq(3)
  end

  it 'can place ships' do
    @player.add_ship("Cruiser", 3)
    allow(@player).to receive(:gets).and_return("A1 A2 A3\n")
    expect { @player.place_ships }.to output.to_stdout
  end

  it 'can take a shot' do
    opponent_board = Board.new(4, 4)
    allow(@player).to receive(:gets).and_return("A1\n")
    expect { @player.take_shot(opponent_board) }.to output.to_stdout
  end

  it 'can report shot result' do
    opponent_board = Board.new(4, 4)
    opponent_board.place(Ship.new("Cruiser", 3), ["A1", "A2", "A3"])
    allow(@player).to receive(:gets).and_return("A1\n")
    expect { @player.take_shot(opponent_board) }.to output(/Your shot on \e\[33mA1\e\[0m was a hit./).to_stdout
  end
end