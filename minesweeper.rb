require './point.rb'
require './minefield_printer.rb'

class ParseError < StandardError; end

class Game
  def initialize
    @minefield_printer = MinefieldPrinter.new
    @minefield = Minefield.new
  end

  def start
    @minefield_printer.print_field(@minefield.cell_states)
    loop do
      player_input = read_user_input
      break if player_input == 'q'
      begin
        point_to_reveal = parse(player_input)
        @minefield.reveal(point_to_reveal)
      rescue ParseError => error
        puts error.message
        next
      rescue OutOfMinefieldBoundsError
        puts 'out of minefield bounds!'
        next
      end
      @minefield_printer.print_field(@minefield.cell_states)
      break if @minefield.finished?
    end

    print "\n"
    if @minefield.finished?
      if @minefield.exploded?
        puts 'You lost :('
      else
        puts 'You won :D'
      end
    else
      puts 'byebye'
    end
  end

  def read_user_input
    print "\n"
    print '> '
    gets.strip
  end

  def parse(input_string)
    input_as_array = input_string.split(',')
    unless input_as_array.length == 2
      raise ParseError, 'Please input two comma-separated coordinates, e.g. 1,2'
    end
    begin
      coordinates = input_as_array.map { |s| Integer(s) }
    rescue ArgumentError
      raise ParseError, 'Coordinates should be integers'
    end
    Point.new(coordinates[0], coordinates[1])
  end
end

game = Game.new
game.start
