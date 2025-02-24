require 'spec_helper.rb'

RSpec.configure do |config|
  config.formatter = :documentation
end

RSpec.describe Color do
  before(:each) do
    @color = Color.new # => #<Color:0x00007f84f0b29d10...>
  end

  describe '#initialize' do
    it 'initialize' do
      expect(@color).to be_an_instance_of(Color) # => true
    end

    it 'has colors' do
      expect(@color.instance_variable_get(:@colors)).to eq({
        red: "\e[31m",
        green: "\e[32m",
        yellow: "\e[33m",
        blue: "\e[34m",
        magenta: "\e[35m",
        cyan: "\e[36m",
        white: "\e[37m",
        reset: "\e[0m"
      }) # => true
    end
  end

  it 'can colorize text' do
    expect(@color.colorize("Hello", :red)).to eq("\e[31mHello\e[0m") # => "\e[31mHello\e[0m"
  end
end