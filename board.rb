class Board
  attr_reader :board

  def initialize
    @board = Array.new(9, ' ')
    @win_conditions = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6]
    ]
  end

  def place_mark(symbol, index)
    @board[index - 1] = symbol
  end

  def unmarked?(box)
    box == ' '
  end

  def display
    segments = [@board[0..2], @board[3..5], @board[6..8]]
    segments.each do |segment|
      puts "#{segment[0]}  |  #{segment[1]}  |  #{segment[2]}"
    end
  end

  def game_ended?
    @win_conditions.any? do |condition|
      combination = condition.each_with_object([]) do |a, total|
        total << @board[a] if @board[a] == 'X' || @board[a] == 'O'
      end
      combination.uniq.length == 1 if combination.length == 3
    end
  end

  def full?
    @board.all? { |spot| spot != ' ' }
  end
end