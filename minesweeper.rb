require './game_state.rb'

class Minesweeper
  def initialize
    @game_state = GameState.new
  end

  def start
    print @game_state.display.to_s
    loop do
      player_input = read_user_input
      @game_state.update(player_input)
      print @game_state.display.to_s
      break if @game_state.game_finished?
    end
  end

  def read_user_input
    print "\n"
    print '> '
    gets.strip
  end
end

Minesweeper.new.start
