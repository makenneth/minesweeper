# Minesweeper
- Classic Minesweeper game
- Has Easy / Medium / Hard mode
- Can use WASD to navigate the grid in terminal
- to play the game, run ruby game.rb


## Feature
- Object-Oriented design - classes are separately clearly
- Uses Recursion to reveal all the neighboring empty cells

```ruby
  def reveal_neighbor(row, col)
     return if beyond_wall?(row) || beyond_wall?(col) ||
               grid[row][col].value != 0 || grid[row][col].flagged ||
               grid[row][col].revealed
               
     grid[row][col].reveal

     DIRS.each do |dir_x, dir_y|
        reveal_neighbor(row + dir_x, col + dir_y)
     end
  end
```

