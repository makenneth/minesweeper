require_relative "tile"
require 'byebug'
class Board
  def self.empty_grid(size = 9)
    Array.new(size) { Array.new(size) }
  end

  def initialize(grid = self.class.empty_grid)
    @grid = grid

    populate_bombs
    populate_safe
  end

  def render
    puts "  #{(0..8).to_a.join(" ")}"
    grid.each_with_index do |row, i|
      p "#{i} #{row.map{ |tile| tile.to_s }.join(" ")}"
    end
  end

  def solved?
    grid.flatten.all? { |tile| tile.revealed || (tile.value == 'b') }
  end

  def lost?(coord)
    self[coord].value == 'b'
  end

  def reveal_neighbor(row, col)
     ((row - 1)..(row + 1)).each do |i|
        ((col - 1)..(col + 1)).each do |j|
           return if beyond_wall?(i) || beyond_wall?(j)
           return if grid[i][j].value != 0 || grid[i][j].flagged || grid[i][j].revealed

           reveal_neighbor(i, j)
        end
     end
  end

  def reveal(coord)
     self[coord].reveal

     reveal_neighbor(*coord) if self[coord].value == 0
  end

  def size
     grid.length
  end

  def is_flagged?(coord)
    grid[coord].flagged
  end


  private
  attr_reader :grid

  def [](pos)
    x, y = pos
    grid[x][y]
  end

  def []=(pos, tile)
    x, y = pos
    grid[x][y] = tile
  end

  def num_bombs
    (grid.size * grid[0].size) / 10 + 1
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

  def beyond_wall?(val)
     val < 0 || val > 8
  end

end
