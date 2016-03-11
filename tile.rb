class Tile
  attr_reader :value, :revealed, :flagged

  def initialize(value)
    @revealed = false
    @flagged = false
    @value = value
  end

  def to_s
    return "f" if flagged

    revealed ? value.to_s : " "
  end

  def reveal
     @revealed = true
  end

  def set_flag
     @flagged = @flagged ? false : true
  end
end
