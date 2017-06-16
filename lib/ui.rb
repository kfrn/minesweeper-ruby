require_relative 'game_board'

class UI
  def initialize(game)
    @game = game
  end

  def print_welcome_message
    puts "Hello and welcome to Minesweeper!"
  end

  def print_game_play_instructions
    puts "Since this is a command-line game, you aren't able to mark mines like in traditional minesweeper."
    puts "The axes are arranged like this:"
    puts
    puts board_layout.map { |elem| elem + "\n" }
    puts
  end

  def board_layout
    [
      "   ↑",
      "10 |",
      " 9 |",
      " 8 |",
      " 7 |",
      " 6 |",
      " 5 |",
      " 4 |",
      " 3 |",
      " 2 |",
      " 1 |",
      "   + ― ― ― ― ― ― ― ― ― ― →",
      "     1 2 3 4 5 6 7 8 9 10"
    ]
  end

  def draw_board(board)
    puts "Here's the board: "
    puts
    puts format_board(board)
    puts
  end

  def show_flags_on_winning_board(board)
    flag_mines_board = board.map do |array|
      array.map do |cell|
        if cell == GameBoard::HIDDEN_CELL
          cell = GameBoard::MINE_FLAG
        else
          cell
        end
      end
    end
    return flag_mines_board
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

  def clear_screen
		system("clear")
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
