require './lib/player'

class Game
  def initialize
    @player = nil
    @computer = nil
    @last_hit = nil
    @difficulty = 'easy'
  end

  def start
    main_menu
  end

  def main_menu
    puts "\e[34mWelcome to BATTLESHIP\e[0m"
    puts "Enter \e[32mp\e[0m to play. Enter \e[31mq\e[0m to quit."
    input = gets.chomp.downcase
    if input == 'p'
      choose_difficulty
      setup_game
    elsif input == 'q'
      puts "\e[31mGoodbye!\e[0m"
    else
      puts "\e[31mInvalid input. Please enter p or q.\e[0m"
      main_menu
    end
  end

  def choose_difficulty
    puts "Choose difficulty level:"
    puts "1. Easy"
    puts "2. Medium"
    puts "3. Hard"
    choice = gets.chomp.to_i

    case choice
    when 1
      @difficulty = 'easy'
    when 2
      @difficulty = 'medium'
    when 3
      @difficulty = 'hard'
    else
      puts "\e[31mInvalid choice. Please enter a number between 1 and 3.\e[0m"
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
      puts "\e[31mInvalid choice. Please enter a number between 1 and 5.\e[0m"
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
        puts "Invalid choice, please type 'm' for manual or 'r' for random placements."
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

  def valid_coordinate?(coordinate)
    letters = ("A"..(65 + @player.board.instance_variable_get(:@height) - 1).chr).to_a
    numbers = (1..@player.board.instance_variable_get(:@width)).to_a
    letter = coordinate[0]
    number = coordinate[1..-1].to_i
    letters.include?(letter) && numbers.include?(number)
  end

  def take_turns
    until game_over?
      system("clear") # Clear the terminal screen
      display_boards
      @player.take_shot(@computer.board)
      computer_shot unless game_over?
    end
    end_game
  end

  def display_boards
    puts "\e[34m=============COMPUTER BOARD=============\e[0m"
    puts @computer.board.render
    puts "\e[34m==============PLAYER BOARD==============\e[0m"
    puts @player.board.render(true)
  end

  def computer_shot
    valid_shot = false
    until valid_shot
      coordinate = intelligent_guess
      if @player.board.valid_coordinate?(coordinate) && !@player.board.cells[coordinate].fired_upon?
        @player.board.cells[coordinate].fire_upon
        valid_shot = true
        puts "My shot on \e[33m#{coordinate}\e[0m was a #{shot_result(@player.board, coordinate)}."
        @last_hit = coordinate if @player.board.cells[coordinate].ship
      end
    end
  end

  def intelligent_guess
    if @difficulty == 'easy'
      random_guess # just disables smart guessing based on hits
    elsif @difficulty == 'medium'
      if @last_hit # hits nearby guesses if computer guesses one and hits
        adjacent_coordinates(@last_hit).find { |coord| @player.board.valid_coordinate?(coord) && !@player.board.cells[coord].fired_upon? } || random_guess
      else
        random_guess
      end
    else # hard difficulty
      if @last_hit
        # Prioritize guessing in a straight line from the last hit
        next_guess = adjacent_coordinates(@last_hit).find { |coord| @player.board.valid_coordinate?(coord) && !@player.board.cells[coord].fired_upon? }
        if next_guess
          next_guess
        else
          # If no valid adjacent coordinates, reset to random guessing
          @last_hit = nil 
          random_guess # sanity check
        end
      else
        random_guess
      end
    end
  end

  def adjacent_coordinates(coordinate)
    letter = coordinate[0]
    number = coordinate[1..-1].to_i
    adjacent = []
    adjacent << "#{(letter.ord - 1).chr}#{number}" if valid_coordinate?("#{(letter.ord - 1).chr}#{number}")
    adjacent << "#{(letter.ord + 1).chr}#{number}" if valid_coordinate?("#{(letter.ord + 1).chr}#{number}")
    adjacent << "#{letter}#{number - 1}" if valid_coordinate?("#{letter}#{number - 1}")
    adjacent << "#{letter}#{number + 1}" if valid_coordinate?("#{letter}#{number + 1}")
    adjacent
  end

  def random_guess
    @player.board.cells.keys.sample
  end

  def shot_result(board, coordinate)
    cell = board.cells[coordinate]
    if cell.empty?
      "\e[31mmiss\e[0m"
    elsif cell.ship.sunk?
      "\e[31mhit and sunk the ship\e[0m"
    else
      "\e[32mhit\e[0m"
    end
  end

  def game_over?
    all_sunk?(@player.board) || all_sunk?(@computer.board)
  end

  def all_sunk?(board)
    board.cells.values.all? { |cell| cell.empty? || cell.ship.sunk? }
  end

  def end_game
    if all_sunk?(@computer.board)
      puts "\e[32mYou won!\e[0m"
    else
      puts "\e[31mI won!\e[0m"
    end
    main_menu
  end
end