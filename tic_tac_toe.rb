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

def center(text)
  WINDOW_SIZE / 2 - text.width / 2
end

def create_component(string, y, size, color)
  component = Text.new(
    string,
    y: y,
    size: size,
    color: color
  )
  component.x = center(component)
  component
end

def create_menu
  title = create_component('TIC TAC TOE', 200, 50, 'black')
  pvp = create_component('Player vs Player', title.y + 100, 24, 'black')
  pvc = create_component('Player vs Computer', pvp.y + 50, 24, 'black')
  [title, pvp, pvc]
end

def generate_grid(x_coord, y_coord)
  grid = []
  index = 0
  3.times do
    3.times do
      tile = {
        position: index,
        tile: create_tile(x_coord, y_coord)
      }
      grid << tile
      x_coord += 200 + TILE_GAP
      index += 1
    end
    x_coord = 0
    y_coord += 200 + TILE_GAP
  end
  grid
end

def mouse_inside_tile?(event, tile)
  event.x.between?(tile[:tile].x1, tile[:tile].x3) &&
    event.y.between?(tile[:tile].y1, tile[:tile].y3)
end

def mouse_inside_button?(event, button)
  event.x.between?(button.x, button.x + button.width) &&
    event.y.between?(button.y, button.y + button.height)
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

def disable(components)
  components.each(&:remove)
end

def disable_grid(grid)
  grid.each { |tile| tile[:tile].remove }
end

def enable_grid(grid)
  grid.each { |tile| tile[:tile].add }
end

def handle_menu(event, components, board, grid)
  if mouse_inside_button?(event, components[1]) ||
     mouse_inside_button?(event, components[2])
    board.menu_active = false
    disable(components)
    enable_grid(grid)
  end
  return unless mouse_inside_button?(event, components[2])

  board.player_mode = false
end

def set_win(marks, board)
  winner = board.last_turn ? 'x' : 'o'
  puts "the winner is #{winner}"
  clear_marks(marks)
  board.clear_board
end

def set_draw(marks, board)
  puts 'it\'s a draw' if board.board_full?
  clear_marks(marks)
  board.clear_board
end

def place_mark(marks, board, tile)
  path = board.current_turn ? PLAYER_X_PATH : PLAYER_O_PATH
  marks << create_mark(path, tile[:tile].x, tile[:tile].y)
  board.update_board(tile[:position])
  board.change_turn
end

def get_free_positions(grid, board)
  grid.filter do |tile|
    board.board_array[tile[:position]].empty?
  end
end

def random_mark(marks, board, grid)
  free_positions = get_free_positions(grid, board)
  return if free_positions.empty? || board.win?

  random_position = free_positions.sample
  place_mark(marks, board, random_position)
end

def handle_game(event, grid, board, marks)
  grid.each do |tile|
    next unless mouse_inside_tile?(event, tile) &&
                board.spot_unmarked?(tile[:position])

    place_mark(marks, board, tile)
    random_mark(marks, board, grid) unless board.player_mode

    if board.win?
      set_win(marks, board)
      next
    end

    next unless board.board_full?

    set_draw(marks, board)

  end
end

menu_components = create_menu
grid = generate_grid(0, 0)

# Disable grid by default
disable_grid(grid)

marks = []

on :mouse_down do |event|
  if event.button == :left
    if board.menu_active
      handle_menu(event, menu_components, board, grid)
    else
      handle_game(event, grid, board, marks)
    end
  end
end

show
