class Board
  attr_accessor :board_array, :x_turn, :winner

  WIN_CONDITIONS = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6]
  ]

  def initialize
    @x_turn = true
    @board_array = Array.new(9, '')
    @winner = ''
  end

  def spot_unmarked?(index)
    board_array[index].empty?
  end

  def update_board(index)
    board_array[index] = x_turn ? 'x' : 'o'
  end

  def change_turn
    self.x_turn = !x_turn
  end

  def board_full?
    board_array.all? { |tile| !tile.empty? }
  end

  def clear_board
    self.board_array = Array.new(9, '')
    self.x_turn = true
  end

  def win?
    WIN_CONDITIONS.any? do |condition|
      line = condition.map { |tile| board_array[tile] }
      line.uniq.length == 1 && !line[0].empty?
    end
  end
end
