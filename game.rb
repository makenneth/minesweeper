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
         coord = get_play
         board.reveal(coord)

         break if board.lost?(coord)
      end

      board.solved? ? "You did it." : "You stepped on a bomb..."
   end

   def get_play
      begin
         coord = player.get_play
         valid_play?(*coord)
      rescue Exception => e
         puts "Oh noes, #{e}"
      retry
      end

      coord
   end

   def valid_play?(row, col)
      raise "Coordinate Error" unless [row, col].all? { |pos| pos.between?(0, board.size - 1) }
   end

end

minesweeper = Game.new
minesweeper.play
