class OutOfMinefieldBoundsError < StandardError; end

class Minefield
  EMPTY = :empty
  HIDDEN = :hidden

  def initialize
    @rows = 10
    @columns = 10
    @revealed = []
    (0...@rows).each_with_object(@revealed) do |_, revealed|
      revealed << [false] * @columns
    end
  end

  def reveal(row, column)
    raise OutOfMinefieldBoundsError unless coordinates_valid?(row, column)
    @revealed[row][column] = true
  end

  def cell_states
    @revealed.map do |row|
      row.map do |is_cell_revealed|
        is_cell_revealed ? EMPTY : HIDDEN
      end
    end
  end

  private

  def coordinates_valid?(row, column)
    0 <= row && row < @rows && 0 <= column && column < @height
  end
end
