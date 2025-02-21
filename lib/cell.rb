class Cell
  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
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

  def render(show_ship = false)
    if @fired_upon
      return "\e[31mX\e[0m" if @ship && @ship.sunk?
      return "\e[32mH\e[0m" if @ship
      return "M"
    else
      return "S" if show_ship && @ship
      return "."
    end
  end
end