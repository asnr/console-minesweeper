require './minefield_printer.rb'

class Game
  def initialize
    @minefield_printer = MinefieldPrinter.new
    @minefield = Minefield.new
  end

  def start
    @minefield_printer.print_field(@minefield.cell_states)
    loop do
      player_input = get_user_input
      break if player_input == 'q'
      coordinates_to_reveal = parse(player_input)
      @minefield.reveal(*coordinates_to_reveal)
      @minefield_printer.print_field(@minefield.cell_states)
    end
  end

  def get_user_input
    print "\n"
    print "> "
    gets.strip
  end

  def parse(input_string)
    input_string.split(',').map { |s| Integer(s) }
  end
end

game = Game.new
game.start
