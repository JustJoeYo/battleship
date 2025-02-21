require './lib/player'

class Game
  def initialize
    @player = Player.new
    @computer = Player.new
  end

  def start
    main_menu
  end

  def main_menu
    puts "\e[34mWelcome to BATTLESHIP\e[0m"
    puts "Enter \e[32mp\e[0m to play. Enter \e[31mq\e[0m to quit."
    input = gets.chomp.downcase
    if input == 'p'
      setup
    elsif input == 'q'
      puts "\e[31mGoodbye!\e[0m"
    else
      puts "\e[31mInvalid input. Please enter p or q.\e[0m"
      main_menu
    end
  end

  def setup
    place_computer_ships
    @player.place_ships
    take_turns
  end

  def place_computer_ships
    [@computer.cruiser, @computer.submarine].each do |ship|
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

  def generate_random_coordinates(length)
    letters = ("A".."D").to_a
    numbers = (1..4).to_a
    start_letter = letters.sample
    start_number = numbers.sample
    direction = ["horizontal", "vertical"].sample

    coordinates = []
    length.times do |i|
      if direction == "horizontal"
        coordinate = "#{start_letter}#{start_number + i}"
        break unless valid_coordinate?(coordinate)
        coordinates << coordinate
      else
        coordinate = "#{(start_letter.ord + i).chr}#{start_number}"
        break unless valid_coordinate?(coordinate)
        coordinates << coordinate
      end
    end
    coordinates
  end

  def valid_coordinate?(coordinate)
    letters = ("A".."D").to_a
    numbers = (1..4).to_a
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
      coordinate = @player.board.cells.keys.sample
      if @player.board.valid_coordinate?(coordinate) && !@player.board.cells[coordinate].fired_upon?
        @player.board.cells[coordinate].fire_upon
        valid_shot = true
        puts "My shot on \e[33m#{coordinate}\e[0m was a #{shot_result(@player.board, coordinate)}."
      end
    end
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