require_relative 'game_board'

class Game

  attr_reader :game_board, :guesses
  attr_accessor :game_lost

  def initialize
    @game_board = GameBoard.new
    @guesses = []
    @game_lost = false
    @empty_cells = []
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
    x_coord = coordinates[:x_value]
    y_coord = coordinates[:y_value]
    @game_board.mine_board[y_coord][x_coord] == GameBoard::MINE
  end

  def reveal_guess(guess, board)
    coordinates = axis_adjusted_coordinates(guess)
    number = number_of_surrounding_mines(coordinates)

    x_coord = coordinates[:x_value]
    y_coord = coordinates[:y_value]

    if mine?(guess)
      board[y_coord][x_coord] = GameBoard::MINE
    elsif number == 0
      board[y_coord][x_coord] = GameBoard::EMPTY_CELL
      @empty_cells.push([x_coord, y_coord])
      show_empty_neighbours(coordinates)
    else
      board[y_coord][x_coord] = number
    end
  end

  private

  def won?
    untouched_cells = @game_board.visible_board.flatten.count(GameBoard::HIDDEN_CELL)
    number_of_mines = @game_board.mine_board.flatten.count(GameBoard::MINE)
    untouched_cells == number_of_mines
  end

  def axis_adjusted_coordinates(guess)
    x_value = guess[:x_coord] - 1
    y_value = GameBoard::BOARD_SIZE - (guess[:y_coord]) # because counting from bottom rather than top
    hash = {x_value: x_value, y_value: y_value}
    puts hash
    {x_value: x_value, y_value: y_value}
  end

  def number_of_surrounding_mines(guess)
    cell_coords = get_surrounding_cell_coords(guess)
    cell_values = get_surrounding_cell_values(cell_coords)

    cell_values.count(GameBoard::MINE)
  end

  def get_surrounding_cell_values(array_of_cell_coords)
    cell_values = []

    array_of_cell_coords.each do |cell|
      x_coord = cell[0]
      y_coord = cell[1]
      cell_values.push(@game_board.mine_board[y_coord][x_coord])
    end

    return cell_values
  end

  def get_surrounding_cell_coords(coordinates)
    x_coord = coordinates[:x_value]
    y_coord = coordinates[:y_value]

    surrounding_cell_coords = []

    if y_coord >= 1                                                                 # up
      surrounding_cell_coords.push([x_coord, y_coord - 1])
    end

    if y_coord < GameBoard::BOARD_SIZE - 1                                          # down
      surrounding_cell_coords.push([x_coord, y_coord + 1])
    end

    if x_coord >= 1                                                                 # left
      surrounding_cell_coords.push([x_coord - 1, y_coord])
    end

    if x_coord < GameBoard::BOARD_SIZE - 1                                          # right
      surrounding_cell_coords.push([x_coord + 1, y_coord])
    end

    if y_coord >= 1 && x_coord >= 1                                                 # top left
      surrounding_cell_coords.push([x_coord - 1, y_coord - 1])
    end

    if y_coord < GameBoard::BOARD_SIZE - 1 && x_coord >= 1                          # bottom left
      surrounding_cell_coords.push([x_coord - 1, y_coord + 1])
    end

    if y_coord >= 1 && x_coord < GameBoard::BOARD_SIZE - 1                          # top right
      surrounding_cell_coords.push([x_coord + 1, y_coord - 1])
    end

    if y_coord < GameBoard::BOARD_SIZE - 1 && x_coord < GameBoard::BOARD_SIZE - 1   # bottom right
      surrounding_cell_coords.push([x_coord + 1, y_coord + 1])
    end

    return surrounding_cell_coords
  end

  def show_empty_neighbours(cell)
    neighbour_cells = get_surrounding_cell_coords(cell)

    neighbour_cells.each do |cell|
      if @empty_cells.include?(cell)
        next
      end

      x_coord = cell[0]
      y_coord = cell[1]

      formatted_cell = {x_value: x_coord, y_value: y_coord}
      cell_value = number_of_surrounding_mines(formatted_cell)

      # NOTE: need to update to show all values adjacent to an empty cell, not just 1s.
      if cell_value == 0
        @empty_cells.push([x_coord, y_coord])
        @game_board.visible_board[y_coord][x_coord] = GameBoard::EMPTY_CELL
        show_empty_neighbours(formatted_cell)
      elsif cell_value == 1
        @game_board.visible_board[y_coord][x_coord] = 1
      end
    end
  end

  def number?(input)
    input.to_i != 0
  end

  def number_in_range?(input)
    input.to_i.between?(1, GameBoard::BOARD_SIZE)
  end
end
