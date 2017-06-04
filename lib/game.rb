require_relative 'game_board'

class Game

  attr_reader :game_board, :guesses
  attr_accessor :game_lost

  def initialize
    @game_board = GameBoard.new
    @guesses = []
    @game_lost = false
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
    coordinates = guess_values(guess)
    x_coord = coordinates[:x_value]
    y_coord = coordinates[:y_value]
    @game_board.mine_board[y_coord][x_coord] == GameBoard::MINE
  end

  def reveal_guess(guess, board)
    number = number_of_surrounding_mines(guess)
    coordinates = guess_values(guess)
    x_coord = coordinates[:x_value]
    y_coord = coordinates[:y_value]

    if mine?(guess)
      board[y_coord][x_coord] = GameBoard::MINE
    elsif number == 0
      board[y_coord][x_coord] = '•'
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

  def guess_values(guess)
    x_value = guess[:x_coord] - 1
    y_value = GameBoard::BOARD_SIZE - (guess[:y_coord]) # because counting from bottom rather than top
    return {x_value: x_value, y_value: y_value}
  end

  def number_of_surrounding_mines(guess)
    coordinates = guess_values(guess)
    cells = surrounding_cell_values(coordinates)

    cells.count(GameBoard::MINE)
  end

  def surrounding_cell_values(coordinates)
    x_coord = coordinates[:x_value]
    y_coord = coordinates[:y_value]

    surrounding_cells = []

    if y_coord >= 1                                                                 # up
      surrounding_cells.push(@game_board.mine_board[y_coord - 1][x_coord])
    end

    if y_coord < GameBoard::BOARD_SIZE - 1                                          # down
      surrounding_cells.push(@game_board.mine_board[y_coord + 1][x_coord])
    end

    if x_coord >= 1                                                                 # left
      surrounding_cells.push(@game_board.mine_board[y_coord][x_coord - 1])
    end

    if x_coord < GameBoard::BOARD_SIZE - 1                                          # right
      surrounding_cells.push(@game_board.mine_board[y_coord][x_coord + 1])
    end

    if y_coord >= 1 && x_coord >= 1                                                 # top left
      surrounding_cells.push(@game_board.mine_board[y_coord - 1][x_coord - 1])
    end

    if y_coord < GameBoard::BOARD_SIZE - 1 && x_coord >= 1                          # bottom left
      surrounding_cells.push(@game_board.mine_board[y_coord + 1][x_coord - 1])
    end

    if y_coord >= 1 && x_coord < GameBoard::BOARD_SIZE - 1                          # top right
      surrounding_cells.push(@game_board.mine_board[y_coord - 1][x_coord + 1])
    end

    if y_coord < GameBoard::BOARD_SIZE - 1 && x_coord < GameBoard::BOARD_SIZE - 1   # bottom right
      surrounding_cells.push(@game_board.mine_board[y_coord + 1][x_coord + 1])
    end

    return surrounding_cells
  end

  def number?(input)
    input.to_i != 0
  end

  def number_in_range?(input)
    input.to_i.between?(1, GameBoard::BOARD_SIZE)
  end

end
