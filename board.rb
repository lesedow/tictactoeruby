class Board
  attr_accessor :board_array
  attr_accessor :x_turn
  def initialize
    @x_turn = true
    @board_array = Array.new(9, '')
  end
  def spot_unmarked?(index)
    board_array[index].empty?
  end
  def update_board(index)
    self.board_array[index] = x_turn ? 'x' : 'o'
    self.x_turn = !self.x_turn 
  end
end