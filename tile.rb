class Tile
  attr_reader :value, :revealed, :flagged

  def initialize(value)
    @revealed = false
    @flagged = false
    @value = value
  end

  def to_s
    return "f" if flagged

    revealed ? value : " "
  end

  def reveal
     revealed == true
  end

end
