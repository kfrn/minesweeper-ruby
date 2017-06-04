require_relative 'game_board'

class UI
  def initialize(game)
    @game = game
  end

  def print_welcome_message
    puts "Hello and welcome to Minesweeper!"
  end

  def draw_board(board)
    puts "Here's the board: "
    puts
    puts format_board(board)
    puts
  end

  def format_board(board_as_nested_array)
    board_as_nested_array.map do |row|
        row.join(" ") + "\n"
    end
  end

  def prompt_user_guess(coordinate)
    puts "Enter the #{coordinate} coordinate of your guess (1 - #{GameBoard::BOARD_SIZE}): "
    gets.chomp.to_i
  end

  def print_wrong_input_message
    puts "Please enter a number in the range 1-#{GameBoard::BOARD_SIZE}"
  end

  def print_mine_message
    puts "BOOM! You're dead!"
  end

  def print_game_over_message
    puts "GAME OVER"
  end

  def print_win_message
    puts "Congrats! You won the game!"
  end
end
