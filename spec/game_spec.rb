require 'spec_helper.rb'

RSpec.describe Game do
  before(:each) do
    @game = Game.new
  end

  describe '#initialize' do
    it 'initializes' do
      expect(@game).to be_instance_of(Game)
    end

    it 'has a player' do
      expect(@game.instance_variable_get(:@player)).to be_nil # not using attr reader so this is the solution, gets the instance variable just the same
    end

    it 'has a computer' do
      expect(@game.instance_variable_get(:@computer)).to be_nil
    end

    it 'last hit is nil' do
      expect(@game.instance_variable_get(:@last_hit)).to be_nil
    end

    it 'has difficulty' do
      expect(@game.instance_variable_get(:@difficulty)).to eq('easy')
    end
  end
end