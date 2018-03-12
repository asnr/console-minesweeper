require './point.rb'

class OutOfMinefieldBoundsError < StandardError; end

class Minefield
  HIDDEN = :hidden
  MINE = :mine

  ADJACENT_OFFSETS = [Point.new(-1, -1), Point.new(-1, 0), Point.new(-1, 1),
                      Point.new( 0, -1),                   Point.new( 0, 1),
                      Point.new( 1, -1), Point.new( 1, 0), Point.new( 1, 1)]

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

  def reveal(point)
    return false unless in_field?(point)
    reveal_just_this point
    reveal_trivial_safe_choices(point) unless mine?(point)
    true
  end

  def cell_states
    (0...@rows).each_with_object([]) do |row_index, cell_states|
      cell_state_row = []
      (0...@columns).each_with_object(cell_state_row) do |column_index, row|
        point = Point.new(row_index, column_index)
        row << cell_state(point)
      end
      cell_states << cell_state_row
    end
  end

  def finished?
    exploded? || all_safe_cells_uncovered?
  end

  def all_safe_cells_uncovered?
    each_point do |point|
      return false unless revealed?(point) || mine?(point)
    end
    true
  end

  private

  def exploded?
    each_point do |point|
      return true if revealed?(point) && mine?(point)
    end
    false
  end

  def reveal_trivial_safe_choices(point)
    return if number_of_adjacent_mines(point) > 0

    to_explore = [point]
    already_explored = []
    until to_explore.empty?
      exploring = to_explore.pop
      each_point_adjacent_to(exploring) do |adjacent_point|
        next if already_explored.include?(adjacent_point)
        reveal_just_this adjacent_point
        if number_of_adjacent_mines(adjacent_point).zero?
          to_explore << adjacent_point
        end
      end
      already_explored << exploring
    end
  end

  def cell_state(point)
    if revealed?(point)
      if mine?(point)
        MINE
      else
        number_of_adjacent_mines(point)
      end
    else
      HIDDEN
    end
  end

  def number_of_adjacent_mines(point)
    number_of_adjacent_mines = 0
    each_point_adjacent_to(point) do |adjacent_point|
      number_of_adjacent_mines += 1 if mine?(adjacent_point)
    end
    number_of_adjacent_mines
  end

  def in_field?(point)
    0 <= point.row && point.row < @rows &&
      0 <= point.column && point.column < @columns
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

  def each_point
    (0...@rows).each do |row|
      (0...@columns).each do |column|
        yield Point.new(row, column)
      end
    end
  end

  def each_point_adjacent_to(point)
    ADJACENT_OFFSETS.each do |offset|
      adjacent_point = point.add(offset)
      yield adjacent_point if in_field?(adjacent_point)
    end
  end

  def mine?(point)
    @mines[point.row][point.column]
  end

  def revealed?(point)
    @revealed[point.row][point.column]
  end

  def reveal_just_this(point)
    @revealed[point.row][point.column] = true
  end
end
