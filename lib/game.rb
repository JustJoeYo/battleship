require './lib/player'
require './lib/color'
require './lib/shoot'

class Game
  def initialize
    @player = nil
    @computer = nil
    @last_hit = nil
    @difficulty = 'easy'
    @color = Color.new
    @shot = Shoot.new
  end

  def start
    intro_screen
    main_menu
  end

  def intro_screen
    system("clear")
    type_out(@color.colorize("Welcome to #{@color.colorize("BATTLESHIP", :blue)}", :white))
    type_out(@color.colorize("Good luck and have fun!", :red))
    sleep(1)
    system("clear")
  end

  def type_out(text)
    text.each_char do |char|
      print char
      sleep(0.1)
    end
    puts
  end

  def main_menu
    puts @color.colorize("Welcome to #{@color.colorize("BATTLESHIP", :blue)}", :white)
    puts "Enter #{@color.colorize('p', :green)} to play. Enter #{@color.colorize('q', :red)} to quit."
    input = gets.chomp.downcase
    if input == 'p'
      choose_difficulty
      setup_game
    elsif input == 'q'
      puts @color.colorize("Goodbye!", :red)
    else
      puts @color.colorize("Invalid input. Please enter p or q.", :red)
      main_menu
    end
  end

  def choose_difficulty
    puts "Choose difficulty level:"
    puts "1. #{@color.colorize("Easy", :green)}"
    puts "2. #{@color.colorize("Medium", :yellow)}"
    puts "3. #{@color.colorize("Hard", :red)}"
    choice = gets.chomp.to_i

    case choice
    when 1
      @difficulty = 'easy'
    when 2
      @difficulty = 'medium'
    when 3
      @difficulty = 'hard'
    else
      puts @color.colorize("Invalid choice. Please enter a number between 1 and 3.", :red)
      choose_difficulty
    end
  end

  def setup_game
    puts "Choose a preset or create a custom game:"
    puts "1. Small game (4x4 board with two 2x1 ships)"
    puts "2. Medium game (6x6 board with one 2x1 and two 3x1 ships)"
    puts "3. Large game (8x8 board with one 4x1, two 3x1, and one 2x1 ships)"
    puts "4. Extra Large game (10x10 board with one 4x1, two 3x1, and one 2x1 ships)"
    puts "5. Custom game"
    choice = gets.chomp.to_i

    case choice
    when 1
      setup_preset(4, 4, [["Ship 1", 2], ["Ship 2", 2]])
    when 2
      setup_preset(6, 6, [["Ship 1", 2], ["Ship 2", 3], ["Ship 3", 3]])
    when 3
      setup_preset(8, 8, [["Ship 1", 4], ["Ship 2", 3], ["Ship 3", 3], ["Ship 4", 2]])
    when 4
      setup_preset(10, 10, [["Ship 1", 4], ["Ship 2", 3], ["Ship 3", 3], ["Ship 4", 2]])
    when 5
      setup_custom_game
    else
      puts @color.colorize("Invalid choice. Please enter a number between 1 and 5.", :red)
      setup_game
    end
  end

  def setup_preset(height, width, ships)
    @player = Player.new(height, width)
    @computer = Player.new(height, width)

    ships.each do |name, length|
      @player.add_ship(name, length)
      @computer.add_ship(name, length)
    end

    setup
  end

  def setup_custom_game
    puts "Enter the height of the board:"
    height = gets.chomp.to_i
    puts "Enter the width of the board:"
    width = gets.chomp.to_i

    @player = Player.new(height, width)
    @computer = Player.new(height, width)

    setup_ships
    setup
  end

  def setup_ships
    puts "Do you want to create custom ships? (y/n)"
    input = gets.chomp.downcase
    if input == 'y'
      create_custom_ships
    else
      @player.add_ship("Cruiser", 3)
      @player.add_ship("Submarine", 2)
      @computer.add_ship("Cruiser", 3)
      @computer.add_ship("Submarine", 2)
    end
  end

  def create_custom_ships
    loop do
      puts "Enter the name of the ship:"
      name = gets.chomp
      puts "Enter the length of the ship:"
      length = gets.chomp.to_i
      @player.add_ship(name, length)
      @computer.add_ship(name, length)
      puts "Do you want to add another ship? (y/n)"
      break if gets.chomp.downcase != 'y'
    end
  end

  def setup
    place_computer_ships
    loop do
      puts "Do you want to place your ships manually or randomly? (m/r)"
      input = gets.chomp.downcase
      if input == 'm'
        @player.place_ships
        break
      elsif input == 'r'
        randomize_player_ships
        break
      else
        puts @color.colorize("Invalid choice, please type 'm' for manual or 'r' for random placements.", :red)
      end
    end
    take_turns
  end

  def place_computer_ships
    @computer.ships.each do |ship|
      placed = false
      until placed
        coordinates = generate_random_coordinates(ship.length)
        if @computer.board.valid_placement?(ship, coordinates)
          @computer.board.place(ship, coordinates)
          placed = true
        end
      end
    end
  end

  def randomize_player_ships
    @player.ships.each do |ship|
      placed = false
      until placed
        coordinates = generate_random_coordinates(ship.length)
        if @player.board.valid_placement?(ship, coordinates)
          @player.board.place(ship, coordinates)
          placed = true
        end
      end
    end
  end

  def generate_random_coordinates(length)
    letters = ("A"..(65 + @player.board.instance_variable_get(:@height) - 1).chr).to_a
    numbers = (1..@player.board.instance_variable_get(:@width)).to_a
    direction = ["horizontal", "vertical"].sample

    coordinates = []
    if direction == "horizontal"
      start_letter = letters.sample
      start_number = numbers.sample(length).sort
      start_number.each do |num|
        coordinate = "#{start_letter}#{num}"
        break unless valid_coordinate?(coordinate)
        coordinates << coordinate
      end
    else
      start_letter = letters.sample(length).sort
      start_number = numbers.sample
      start_letter.each do |let|
        coordinate = "#{let}#{start_number}"
        break unless valid_coordinate?(coordinate)
        coordinates << coordinate
      end
    end
    coordinates
  end

  def valid_coordinate?(coordinate) # super redundant, but I'm pressed for time and need it to work (refactor later)
    letters = ("A"..(65 + @player.board.instance_variable_get(:@height) - 1).chr).to_a
    numbers = (1..@player.board.instance_variable_get(:@width)).to_a
    letter = coordinate[0]
    number = coordinate[1..-1].to_i
    letters.include?(letter) && numbers.include?(number)
  end

  def take_turns
    until game_over?
      system("clear")
      display_boards
      @player.take_shot(@computer.board)
      @shot.computer_shot(@computer, @player, @difficulty, @last_hit)
      @last_hit = @shot.last_hit
    end
    end_game
  end

  def display_boards
    puts @color.colorize("=============COMPUTER BOARD=============", :blue)
    puts @computer.board.render
    puts @color.colorize("==============PLAYER BOARD==============", :blue)
    puts @player.board.render(true)
  end

  def game_over?
    all_sunk?(@player.board) || all_sunk?(@computer.board)
  end

  def all_sunk?(board)
    board.cells.values.all? { |cell| cell.empty? || cell.ship.sunk? }
  end

  def end_game
    if all_sunk?(@computer.board)
      puts @color.colorize("You won!", :green)
    else
      puts @color.colorize("I won!", :red)
    end
    main_menu
  end
end