class Shoot
  attr_reader :last_hit

  def initialize
    @last_hit = nil
  end

  def computer_shot(computer, player, difficulty, last_hit)
    valid_shot = false
    until valid_shot
      coordinate = intelligent_guess(player, difficulty, last_hit)
      if player.board.valid_coordinate?(coordinate) && !player.board.cells[coordinate].fired_upon?
        player.board.cells[coordinate].fire_upon
        valid_shot = true
        puts "My shot on #{coordinate} was a #{player.shot_result(player.board, coordinate)}."
        @last_hit = coordinate if player.board.cells[coordinate].ship
      end
    end
  end

  def intelligent_guess(player, difficulty, last_hit)
    if difficulty == 'easy'
      random_guess(player)
    elsif difficulty == 'medium'
      if last_hit # no idea how to do this in a less ugly way, manually creating the array of adjacent coordinates to last hit is the best I could come up with
        adjacent_coordinates(player, last_hit).find { |coord| player.board.valid_coordinate?(coord) && !player.board.cells[coord].fired_upon? } || random_guess(player)
      else
        random_guess(player)
      end
    else
      if last_hit
        next_guess = adjacent_coordinates(player, last_hit).find { |coord| player.board.valid_coordinate?(coord) && !player.board.cells[coord].fired_upon? }
        if next_guess
          next_guess
        else
          @last_hit = nil # just resets back to default nil, this is so it stops hunting that ship
          random_guess(player)
        end
      else
        pattern_guess(player)
      end
    end
  end

  def pattern_guess(player)
    cells = player.board.cells.keys.select.with_index { |_, i| i.even? }
    cells.find { |coord| !player.board.cells[coord].fired_upon? } || random_guess(player)
  end

  def adjacent_coordinates(player, coordinate)
    letter = coordinate[0]
    number = coordinate[1..-1].to_i
    adjacent = []
    adjacent << "#{(letter.ord - 1).chr}#{number}" if valid_coordinate?(player, "#{(letter.ord - 1).chr}#{number}")
    adjacent << "#{(letter.ord + 1).chr}#{number}" if valid_coordinate?(player, "#{(letter.ord + 1).chr}#{number}")
    adjacent << "#{letter}#{number - 1}" if valid_coordinate?(player, "#{letter}#{number - 1}")
    adjacent << "#{letter}#{number + 1}" if valid_coordinate?(player, "#{letter}#{number + 1}")
    adjacent
  end

  def random_guess(player)
    player.board.cells.keys.sample
  end

  # super redundant, but I'm pressed for time and need it to work (refactor later)
  def valid_coordinate?(player, coordinate) # not to be mixed up with boards valid_coordinate? method, this is just for the shooting.
    letters = ("A"..(65 + player.board.instance_variable_get(:@height) - 1).chr).to_a
    numbers = (1..player.board.instance_variable_get(:@width)).to_a
    letter = coordinate[0]
    number = coordinate[1..-1].to_i
    letters.include?(letter) && numbers.include?(number)
  end
end