require 'ruby2d'
require './board'

WINDOW_SIZE = 680
TILE_GAP = 20
TILE_SIZE = 200
TILE_COLOR = 'white'
TABLE_BACKGROUND = 'gray'
PLAYER_X_PATH = './assets/X.png'
PLAYER_O_PATH = './assets/O.png'

board = Board.new

set(
  title: 'Tic Tac Toe',
  background: TABLE_BACKGROUND,
  height: WINDOW_SIZE,
  width: WINDOW_SIZE
)

def create_tile(x_coord, y_coord)
  Square.new(
    x: TILE_GAP + x_coord,
    y: TILE_GAP + y_coord,
    color: TILE_COLOR,
    size: TILE_SIZE
  )
end

def generate_table(x_coord, y_coord)
  table = []
  index = 0
  3.times do
    3.times do
      tile = {
        position: index,
        tile: create_tile(x_coord, y_coord)
      }
      table << tile
      x_coord += 200 + TILE_GAP
      index += 1
    end
    x_coord = 0
    y_coord += 200 + TILE_GAP
  end
  table
end

def mouse_inside_tile?(event, tile)
  event.x.between?(tile[:tile].x1, tile[:tile].x3) &&
    event.y.between?(tile[:tile].y1, tile[:tile].y3)
end

def create_mark(mark_path, x_coord, y_coord)
  Image.new(
    mark_path,
    x: x_coord,
    y: y_coord,
    width: 200,
    height: 200
  )
end

def clear_marks(marks)
  marks.each(&:remove)
  marks.clear
end

table = generate_table(0, 0)
marks = []

on :mouse_down do |event|
  if event.button == :left
    table.each do |tile|
      next unless mouse_inside_tile?(event, tile) &&
      board.spot_unmarked?(tile[:position])

      path = board.x_turn ? PLAYER_X_PATH : PLAYER_O_PATH
      marks << create_mark(path, tile[:tile].x, tile[:tile].y)
      board.update_board(tile[:position])

      if board.win?
        winner = board.x_turn ? 'x' : 'o'
        puts "the winner is #{winner}"
        marks = clear_marks(marks)
        board.clear_board
        next
      end

      board.change_turn

      next unless board.board_full?

      puts 'board full' if board.board_full?
      marks = clear_marks(marks)
      board.clear_board
    end
  end
end

show
