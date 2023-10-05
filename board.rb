class Board
  attr_accessor :board_array, :current_turn, :winner, :player_mode, :menu_active, 
  :last_turn

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
    @current_turn = true # current_turn = true - is x's turn and false is o's turn
    @last_turn = false
    @board_array = Array.new(9, '')
    @player_mode = true
    @menu_active = true
  end

  def spot_unmarked?(index)
    board_array[index].empty?
  end

  def update_board(index)
    board_array[index] = current_turn ? 'x' : 'o'
  end

  def change_turn
    self.last_turn = current_turn
    self.current_turn = !current_turn
  end

  def board_full?
    board_array.all? { |tile| !tile.empty? }
  end

  def clear_board
    self.board_array = Array.new(9, '')
    self.current_turn = true
    self.last_turn = false
  end

  def win?
    WIN_CONDITIONS.any? do |condition|
      line = condition.map { |tile| board_array[tile] }
      line.uniq.length == 1 && !line[0].empty?
    end
  end
end
