class Ship
  def initialize(name, length, coordinates = [])
    @name = name # these 3 could be in an attr_reader but alec said it aint 
    @length = length # great to put everything into an attr reader due to security reasons.
    @health = length # in this project I will avoid using attr_accessors/readers
    @coordinates = []
  end

  def name
    @name
  end

  def length
    @length
  end

  def health
    @health
  end

  def coordinates
    @coordinates
  end

  def hit
    @health -= 1 if @health > 0
  end

  def sunk?
    @health == 0
  end
end