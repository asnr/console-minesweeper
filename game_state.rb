require './minefield.rb'
require './display.rb'

class GameState
  attr_reader :display
  def initialize
    @minefield = Minefield.new
    @display = DisplayMinefield.new(@minefield.cell_states,
                                    finished: false,
                                    won: false)
    @player_quit = false
  end

  def update(player_input_string)
    if player_input_string == 'q'.freeze
      @display = DisplayPlayerQuits.new
      @player_quit = true
      return
    end

    coordinates = parse(player_input_string)
    return unless coordinates

    coordinates_in_field = @minefield.reveal(coordinates)
    @display = if coordinates_in_field
                 DisplayMinefield.new(@minefield.cell_states,
                                      finished: @minefield.finished?,
                                      won: @minefield.all_safe_cells_uncovered?)
               else
                 DisplayCoordinatesOutOfField.new
               end
  end

  def game_finished?
    @player_quit || @minefield.finished?
  end

  private

  def parse(player_input_string)
    input_as_array = player_input_string.split(',')
    unless input_as_array.length == 2
      @display = DisplayWrongNumberOfCoordinates.new
      return nil
    end

    begin
      coordinates = input_as_array.map { |s| Integer(s) }
    rescue ArgumentError
      @display = DisplayProvideIntegerInput.new
      return nil
    end

    Point.new(coordinates[0], coordinates[1])
  end
end
