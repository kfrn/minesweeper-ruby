class GameBoard
  BOARD_SIZE = 10 # square
  MINE = 'x'
  HIDDEN_CELL = '⬜'
  TOTAL_CELLS = BOARD_SIZE * BOARD_SIZE
  EMPTY_CELL = '•'
  DIFFICULTY = 0.8 # between 0 and 1; the probability that the cell is not a mine.

  attr_reader :mine_board, :visible_board

  def initialize
    @visible_board = generate_clean_grid
    @mine_board = generate_grid_with_mines(@visible_board)
  end

  def generate_clean_grid
    Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE, HIDDEN_CELL) }
  end

  def generate_grid_with_mines(nested_array)
    mine_array = nested_array.map do |array|
      array.map do |cell|
        set_cell_status(generate_random_number) ? MINE : HIDDEN_CELL
      end
    end
    mine_array
  end

  private

  def generate_random_number
    Random.new.rand(1...(TOTAL_CELLS))
  end

  def set_cell_status(random_number)
    mine_cutoff_point = TOTAL_CELLS * DIFFICULTY
    random_number > mine_cutoff_point
  end
end
