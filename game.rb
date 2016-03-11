require_relative 'player'
require_relative 'board'
class Game
   attr_reader :board, :player

   def initialize(board = Board.new, player = Player.new("Johnny"))
      @board = board
      @player = player
   end

   def play
      until board.solved?
         board.render
         coord, what_to_do = get_play

         what_to_do == "R" ? board.reveal(coord) : board.flag(coord)

         break if board.lost?(coord) && !board.is_flagged?(coord)
      end
      board.render
      p board.solved? ? "You did it." : "You stepped on a bomb..."
   end

   def get_play
      begin
         coord = player.get_play
         what_to_do = player.deciding_move

         valid_play?(coord)
         valid_input?(what_to_do)

         is_flagged?(coord) if what_to_do == "R"
      rescue Exception => e
         puts "Oh noes, #{e}"
      retry
      end

      return coord, what_to_do
   end

   def valid_input?(char)
      raise "Input Error" unless char == "R" || char == "F"
   end

   def valid_play?(coord)
      raise "Coordinate Error" unless coord.all? { |pos| pos.between?(0, board.size - 1) }
   end

   def is_flagged?(coord)
      raise "Flag Error" if board.is_flagged?(coord)

   end

end

minesweeper = Game.new
minesweeper.play
