require_relative "tile"
require 'byebug'
require 'colorize'

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
      puts "#{i} #{map_row(row).join(" ".colorize({background: :light_white}))}"
    end
  end

  def map_row(row)
     row.map do |tile|
        if tile.to_s == " "
           tile.to_s.colorize({background: :light_white})
        else
           tile.to_s.colorize(color_of_tile(tile.to_s))
        end
     end
  end

  def color_of_tile(tile)
     color = case tile
     when "1"
        :light_blue
     when "2"
        :light_green
     when "3"
        :light_red
     when "4"
        :blue
     when "5"
        :magenta
     when "6"
        :light_cyan
     when "7"
        :black
     when "8"
        :light_black
     when "b"
        :black
     end


     {background: :light_black, color: color, mode: :bold}
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
     val < 0 || val > 8
  end

end
