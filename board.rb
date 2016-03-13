require_relative "tile"
require 'byebug'

class Board
  attr_reader :grid

  def self.empty_grid(size = 10)
    Array.new(size) { Array.new(size) }
  end

  def initialize(option={:diff=>:easy, :size=>9})
    @grid = self.class.empty_grid(option[:size])
    @modifier = option[:easy] ? 10 : option[:hard] ? 5 : 7.5
    populate_bombs
    populate_safe
  end

  def solved?
    grid.flatten.all? { |tile| tile.revealed || tile.value == 'b' }
  end

  def lost?(coord)
    self[coord].value == 'b'
  end

  def reveal(coord)
     self[coord].value == 0 ? reveal_neighbor(*coord) : self[coord].reveal
  end

  def flag(coord)
     self[coord].set_flag
  end

  def size
     grid.length
  end

  def is_flagged?(coord)
    self[coord].flagged
  end

  def within_bound?(coord)
     coord.all? { |pos| pos.between?(0, size - 1) }
  end

  def valid_play?(coord)
     raise "Coordinate Error" unless coord.all? { |pos| pos.between?(0, size - 1) }
  end

  private

  def [](pos)
    x, y = pos
    grid[x][y]
  end

  def []=(pos, tile)
    x, y = pos
    grid[x][y] = tile
  end

  def num_bombs
    (grid.size * grid[0].size) / @modifier + 1
  end

  def valid_bomb?(coord)
      self[coord].nil?
  end

  def populate_bombs
    (0...num_bombs).each do |_|
      coord = []
      loop do
        coord = [rand(grid.size), rand(grid[0].size)]
        break if valid_bomb?(coord)
      end

      self[coord] = Tile.new('b')
    end
  end

  def populate_safe
    grid.size.times do |i|
      grid[0].size.times do |j|
        next unless grid[i][j].nil?

        grid[i][j] = Tile.new(surrounding_bombs(i, j))
      end
    end
  end

  def surrounding_bombs(row, col)
    count = 0

    ((row - 1)..(row + 1)).each do |i|
      ((col - 1)..(col + 1)).each do |j|
        next if beyond_wall?(i) || beyond_wall?(j) || grid[i][j].nil?

        count += 1 if grid[i][j].value == 'b'
      end
    end

    count
  end

  def reveal_neighbor(row, col)
     return if beyond_wall?(row) || beyond_wall?(col) ||
               grid[row][col].value != 0 || grid[row][col].flagged ||
               grid[row][col].revealed

     directions  = [[row - 1, col - 1], [row + 1, col + 1],
            [row - 1, col + 1], [row + 1, col - 1],
            [row - 1, col], [row, col - 1],
            [row + 1, col], [row, col + 1]]

     grid[row][col].reveal

     directions.each do |direction|
        reveal_neighbor(*direction)
     end

  end

  def beyond_wall?(val)
     val < 0 || val >= size
  end

end
