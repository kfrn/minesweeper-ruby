require_relative 'ui'
require_relative 'game'

class Minesweeper
  def initialize
    @game = Game.new
    @ui = UI.new(@game)
    @board = @game.game_board
  end

  def play
    @ui.print_welcome_message
    @ui.print_game_play_instructions

    play_turn while @game.in_progress?

    if @game.lost?
      @ui.print_game_over_message
    elsif @game.won?
      @ui.print_win_message
    end
  end

  private

  def play_turn
    # @ui.draw_board(@board.mine_board)
    @ui.draw_board(@board.visible_board)

    x_coord = enter_guess("x")
    y_coord = enter_guess("y")
    guess = {x_coord: x_coord, y_coord: y_coord}
    @game.guesses.push(guess)

    if @game.mine?(guess)
      @game.game_lost = true
      @game.reveal_guess(guess, @board.visible_board)
      @ui.draw_board(@board.visible_board)
      @ui.print_mine_message
    else
      @game.reveal_guess(guess, @board.visible_board)
    end
  end

  def enter_guess(coordinate)
    loop do
      guess = @ui.prompt_user_guess(coordinate)
      break guess if @game.guess_valid?(guess)
      @ui.print_wrong_input_message
    end
  end
end

Minesweeper.new.play
