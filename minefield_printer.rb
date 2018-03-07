require './minefield.rb'

class MinefieldPrinter
  def print_field(minefield_states)
    pretty_states = prettify_states(minefield_states)
    pretty_states.each do |row|
      puts row.join(' ')
    end
  end

  def prettify_states(minefield_states)
    minefield_states.map do |row|
      row.map do |cell_state|
        if cell_state == Minefield::HIDDEN
          '-'
        elsif cell_state == Minefield::MINE
          'X'
        elsif cell_state == 0
          ' '
        else
          cell_state
        end
      end
    end
  end
end
