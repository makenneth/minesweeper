class Player
   def initialize(name)
      @name = name
   end

   def get_play
      p "Please enter your play, (x, y)"
      gets.chomp.split(",").map(&:to_i)
   end
end
