require_relative 'player'
require_relative 'board'
require_relative 'display'
class Game
   attr_reader :board, :player

   def initialize(board=Board.new, player = Player.new("Johnny"))
      @board = board
      @player = player
   end

   def play
      @display = Display.new(@board)

      until board.solved?
         coord, what_to_do = get_play

         what_to_do == :reveal ? board.reveal(coord) : board.flag(coord)

         break if board.lost?(coord) && !board.is_flagged?(coord)
      end
      @display.render
      p board.solved? ? "You did it." : "You stepped on a bomb..."
   end

   def get_play
      coord = nil
      until coord
         system('clear')
         @display.render
         coord, what_to_do = @display.get_move
      end
      begin
         board.valid_play?(coord)
         is_flagged?(coord) if what_to_do == :reveal
      rescue Exception => e
         puts "Oh noes, #{e}"
      end

      return coord, what_to_do
   end

private

   def is_flagged?(coord)
      raise "Flag Error" if board.is_flagged?(coord)
   end

end

if __FILE__ == $PROGRAM_NAME
   difficulties = {:H=>{
                     :diff=>:hard,
                     :size=>15},
                   :M=>{
                      :diff=>:medium,
                      :size=>12},
                   :E=>{
                      :diff=>:easy,
                      :size=>9}
                   }

   puts "What difficulty would you like to play in? E/M/H"
   conditions = difficulties[gets.chomp.to_sym]

   minesweeper = Game.new(Board.new(conditions))
   minesweeper.play
end
