class Point
  attr_reader :row, :column
  def initialize(row, column)
    @row = row
    @column = column
  end

  def add(other_point)
    Point.new(@row + other_point.row, @column + other_point.column)
  end

  def ==(other)
    @row == other.row && @column == other.column
  end
end
