class OutOfMinefieldBoundsError < StandardError; end

class Minefield
  EMPTY = :empty
  HIDDEN = :hidden
  MINE = :mine

  def initialize
    @rows = 10
    @columns = 10
    @number_of_mines = 10
    @revealed = []
    (0...@rows).each_with_object(@revealed) do |_, revealed|
      revealed << [false] * @columns
    end
    @mines = random_2d_mine_array
  end

  def reveal(row, column)
    raise OutOfMinefieldBoundsError unless coordinates_valid?(row, column)
    @revealed[row][column] = true
  end

  def cell_states
    (0...@rows).each_with_object([]) do |row_index, cell_states|
      cell_state_row = []
      (0...@columns).each_with_object(cell_state_row) do |column_index, row|
        row << cell_state(row_index, column_index)
      end
      cell_states << cell_state_row
    end
  end

  def finished?
    exploded? || all_safe_cells_uncovered?
  end

  def exploded?
    (0...@rows).each do |row|
      (0...@columns).each do |column|
        return true if @revealed[row][column] && @mines[row][column]
      end
    end
    false
  end

  private

  def all_safe_cells_uncovered?
    (0...@rows).each do |row|
      (0...@columns).each do |column|
        return false unless @revealed[row][column] || @mines[row][column]
      end
    end
    true
  end

  def cell_state(row, column)
    if @revealed[row][column]
      if @mines[row][column]
        MINE
      else
        number_of_adjacent_mines(row, column)
      end
    else
      HIDDEN
    end
  end

  ADJACENT_OFFSETS = [[-1, -1], [-1, 0], [-1, 1],
                      [ 0, -1],          [ 0, 1],
                      [ 1, -1], [ 1, 0], [ 1, 1]]
  def number_of_adjacent_mines(row, column)
    number_of_adjacent_mines = 0
    ADJACENT_OFFSETS.each do |row_offset, column_offset|
      adjacent_row = row + row_offset
      adjacent_column = column + column_offset
      if coordinates_valid?(adjacent_row, adjacent_column) &&
         @mines[adjacent_row][adjacent_column]
        number_of_adjacent_mines += 1
      end
    end
    number_of_adjacent_mines
  end

  def coordinates_valid?(row, column)
    0 <= row && row < @rows && 0 <= column && column < @columns
  end

  def random_2d_mine_array
    number_cells_in_minefield = @rows * @columns
    number_of_safe_cells = number_cells_in_minefield - @number_of_mines
    ordered_flat_mine_array = [true] * @number_of_mines +
                              [false] * number_of_safe_cells
    flat_mine_array = ordered_flat_mine_array.shuffle
    mine_array = []
    (0...@rows).each do |row_index|
      first_index_of_row = row_index * @columns
      last_index_of_row = first_index_of_row + @columns - 1
      mine_array << flat_mine_array[first_index_of_row..last_index_of_row]
    end
    mine_array
  end
end
