class Cell
  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil # best way to initialize the value, will redefine later.
    @fired_upon = false
  end

  def coordinate
    @coordinate
  end

  def ship
    @ship
  end

  def empty?
    @ship.nil?
  end

  def place_ship(ship)
    @ship = ship
  end

  def fired_upon?
    @fired_upon
  end

  def fire_upon
    if !@fired_upon
      @fired_upon = true
      @ship.hit if @ship
    end
  end

  def render(show_ship = false) # renders the board
    if @fired_upon # logic for shot squares
      return "X" if @ship && @ship.sunk? # sunk ship
      return "H" if @ship # hit
      return "M" # miss
    else # logic for unshot squares
      return "S" if show_ship && @ship
      return "."
    end
  end
end