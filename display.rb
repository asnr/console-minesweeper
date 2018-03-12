class DisplayPlayerQuits
  def to_s
    "Goodbye!\n".freeze
  end
end

class DisplayWrongNumberOfCoordinates
  def to_s
    "Please enter a pair of numbers delimited by a comma, e.g. '1,1'".freeze
  end
end

class DisplayProvideIntegerInput
  def to_s
    'Each coordinate needs to be an integer'.freeze
  end
end

class DisplayCoordinatesOutOfField
  def to_s
    'Those coordinates are not in the minefield'.freeze
  end
end

class DisplayMinefield
  def initialize(minefield_cell_states, finished:, won:)
    @minefield_cell_states = minefield_cell_states
    @finished = finished
    @won = won
  end

  def to_s
    pretty_states = prettify_states(@minefield_cell_states)
    pretty_rows = pretty_states.map { |row| row.join(' ') }
    output = "\n#{pretty_rows.join("\n")}\n"
    if @finished
      output = if @won
                 "#{output}\nYou won! All the mines have been cleared.\n"
               else
                 "#{output}\nYou've hit a mine :(\n"
               end
    end
    output
  end

  private

  def prettify_states(minefield_cell_states)
    minefield_cell_states.map do |row|
      row.map do |cell_state|
        if cell_state == Minefield::HIDDEN
          '-'
        elsif cell_state == Minefield::MINE
          'X'
        elsif cell_state.zero?
          ' '
        else
          cell_state
        end
      end
    end
  end
end
