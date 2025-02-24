class Color
  def initialize
    @colors = {
      red: "\e[31m",
      green: "\e[32m",
      yellow: "\e[33m",
      blue: "\e[34m",
      magenta: "\e[35m",
      cyan: "\e[36m",
      white: "\e[37m",
      reset: "\e[0m"
    }
  end

  def colorize(text, color)
    "#{@colors[color]}#{text}#{@colors[:reset]}"
  end
end