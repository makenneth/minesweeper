class Player
   def initialize(name)
      @name = name
   end

   def deciding_move
      p "Would you like to place a flag or reveal? F/R"
      gets.chomp
   end

   def get_play
      p "Please enter your play, (x, y)"
      gets.chomp.split(",").map(&:to_i)
   end
end
