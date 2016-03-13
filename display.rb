require_relative 'cursorable'
require 'colorize'
class Display
   include Cursorable

   def initialize(board)
      @board = board
      @cursor_pos = [0, 0]
   end

   def get_move
      p "Please use WASD, and press F/R at location (flag/reveal)"
      get_input
   end

   def render
     @board.grid.each_with_index do |row, i|
       puts " #{map_row(row, i).join(" ")}"
     end
   end

   def map_row(row, i)
      row.map.with_index do |tile, j|
        if tile.to_s == " "
            tile = tile.to_s
        else
            tile = tile.to_s.colorize(color_of_tile(tile.to_s))
        end
        [i,j] == @cursor_pos ? tile.to_s.colorize({background: :white}) : tile
      end
   end

   def color_of_tile(tile)
      color = case tile
      when "0"
        :black
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


end
