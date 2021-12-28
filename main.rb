require './player'
require './board'

class Game
  def initialize
    @board = Board.new
    @player1 = create_player('First player name:')
    @player2 = create_player('Second player name:')
    @first_player_turn = true
    game_loop
  end

  def end_game
    if @board.game_ended?
      winner = @first_player_turn ? @player1.name : @player2.name
      puts "Game Over! The winner is #{winner}"
      return
    end
    puts "It's a tie!"
  end

  def game_loop
    until @board.full?
      @board.display
      puts "It's #{@first_player_turn ? @player1.name : @player2.name }'s turn!"
      play_turn
      break if @board.game_ended?

      @first_player_turn = !@first_player_turn
    end
    end_game
  end

  def play_turn
    spot = get_input('Select a spot where you want to place your mark.(1-9)').to_i
    mark = @first_player_turn ? 'X' : 'O'
    if @board.unmarked?(@board.board[spot - 1])
      @board.place_mark(mark, spot)
    else
      puts 'This spot is already taken!'
      play_turn
    end
  end

  def create_player(prompt)
    player_name = get_input(prompt)
    Player.new(player_name)
  end

  def get_input(prompt)
    puts prompt
    gets.chomp
  end
end

Game.new
