require_relative 'game_board'
require_relative 'coordinates'

class Game

  attr_reader :game_board
  attr_accessor :game_lost

  def initialize
    @game_board = GameBoard.new
    @game_lost = false
    @empty_cells = []
  end

  def won?
    untouched_cells = @game_board.visible_board.flatten.count(GameBoard::HIDDEN_CELL)
    number_of_mines = @game_board.mine_board.flatten.count(GameBoard::MINE)
    untouched_cells == number_of_mines
  end

  def in_progress?
    !(won? || lost?)
  end

  def lost?
    @game_lost
  end

  def guess_valid?(input)
    number?(input) && number_in_range?(input)
  end

  def mine?(guess)
    coordinates = axis_adjusted_coordinates(guess)

    @game_board.mine_board[coordinates.y][coordinates.x] == GameBoard::MINE
  end

  def reveal_guess(guess, board)
    coordinates = axis_adjusted_coordinates(guess)
    number = number_of_surrounding_mines(coordinates)

    if mine?(guess)
      board[coordinates.y][coordinates.x] = GameBoard::MINE
    elsif number == 0
      board[coordinates.y][coordinates.x] = GameBoard::EMPTY_CELL
      @empty_cells.push(coordinates)
      show_empty_neighbours(coordinates)
    else
      board[coordinates.y][coordinates.x] = number
    end
  end

  private

  def axis_adjusted_coordinates(guess)
    x_value = guess.x - 1
    y_value = GameBoard::BOARD_SIZE - (guess.y) # because counting from bottom rather than top
    return CoordinatePair.new(x_value, y_value)
  end

  def number_of_surrounding_mines(guess)
    cell_coords = get_surrounding_cell_coords(guess)
    cell_values = get_surrounding_cell_values(cell_coords)
    cell_values.count(GameBoard::MINE)
  end

  def get_surrounding_cell_values(array_of_cell_coords)
    cell_values = []

    array_of_cell_coords.each do |cell|
      cell_values.push(@game_board.mine_board[cell.y][cell.x])
    end

    return cell_values
  end

  def get_surrounding_cell_coords(coordinates)
    surrounding_cell_coords = []

    if coordinates.y >= 1                                                                 # up
      surrounding_cell_coords.push(CoordinatePair.new(coordinates.x, coordinates.y - 1))
    end

    if coordinates.y < GameBoard::BOARD_SIZE - 1                                          # down
      surrounding_cell_coords.push(CoordinatePair.new(coordinates.x, coordinates.y + 1))
    end

    if coordinates.x >= 1                                                                 # left
      surrounding_cell_coords.push(CoordinatePair.new(coordinates.x - 1, coordinates.y))
    end

    if coordinates.x < GameBoard::BOARD_SIZE - 1                                          # right
      surrounding_cell_coords.push(CoordinatePair.new(coordinates.x + 1, coordinates.y))
    end

    if coordinates.y >= 1 && coordinates.x >= 1                                                 # top left
      surrounding_cell_coords.push(CoordinatePair.new(coordinates.x - 1, coordinates.y - 1))
    end

    if coordinates.y < GameBoard::BOARD_SIZE - 1 && coordinates.x >= 1                          # bottom left
      surrounding_cell_coords.push(CoordinatePair.new(coordinates.x - 1, coordinates.y + 1))
    end

    if coordinates.y >= 1 && coordinates.x < GameBoard::BOARD_SIZE - 1                          # top right
      surrounding_cell_coords.push(CoordinatePair.new(coordinates.x + 1, coordinates.y - 1))
    end

    if coordinates.y < GameBoard::BOARD_SIZE - 1 && coordinates.x < GameBoard::BOARD_SIZE - 1   # bottom right
      surrounding_cell_coords.push(CoordinatePair.new(coordinates.x + 1, coordinates.y + 1))
    end

    return surrounding_cell_coords
  end

  def show_empty_neighbours(cell)
    neighbour_cells = get_surrounding_cell_coords(cell)

    neighbour_cells.each do |cell|
      if @empty_cells.include?(cell)
        next
      end

      reveal_neighbours_on_board(cell)
    end
  end

  def reveal_neighbours_on_board(cell)
    cell_value = number_of_surrounding_mines(cell)

    if cell_value == 0
      @empty_cells.push(cell)
      @game_board.visible_board[cell.y][cell.x] = GameBoard::EMPTY_CELL
      show_empty_neighbours(cell)
    else
      @game_board.visible_board[cell.y][cell.x] = cell_value
    end
  end

  def number?(input)
    input.to_i != 0
  end

  def number_in_range?(input)
    input.to_i.between?(1, GameBoard::BOARD_SIZE)
  end
end
