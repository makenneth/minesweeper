require_relative 'cursorable'
class Player
   include Cursorable

   def initialize(name)
      @name = name
      @cursor_pos = [0, 0]
   end

   def deciding_move
      p "Would you like to place a flag or reveal? F/R"
      gets.chomp
   end

   def get_move
      p "Please use WASD, and press enter at location"
      get_input
   end
end
