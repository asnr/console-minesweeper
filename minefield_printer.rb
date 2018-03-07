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
        if cell_state == Minefield::EMPTY
          ' '
        elsif cell_state == Minefield::HIDDEN
          'O'
        else
          raise StandardError, 'Cell state not recognised'
        end
      end
    end
  end
end
