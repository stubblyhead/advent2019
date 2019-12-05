require 'pry'
binding.pry

input = File.readlines('./input', :chomp=>true)

width_a, width_b, height_a, height_b = 0,0,0,0

grid = Array.new(1000) { Array.new(1000) { [false, false] }}
row_o = col_o = row = col = grid.length / 2
grid[row][col] = 'O'

def move(grid, row, col, step, wire)
  direction = step[0]
  length = step[1..-1].to_i

  case direction
  when 'U'
    length.times {
      row -= 1
      grid[row][col][wire] = true
    }
  when 'D'
    length.times {
      row += 1
      grid[row][col][wire] = true
    }
  when 'R'
    length.times {
      col += 1
      grid[row][col][wire] = true
    }
  when 'L'
    length.times {
      col -= 1
      grid[row][col][wire] = true
    }
  end
  [grid, row, col]

end

wire_a = input[0]
wire_b = input[1]

wire_a.split(',').each do |step|
  grid, row, col = move(grid, row, col, step, 0)
end

row, col = [row_o, col_o]

wire_b.split(',').each do |step|
  grid, row, col = move(grid, row, col, step, 1)
end

intersections = []
grid.each_index do |row|
  while grid[row].include?([true, true])
    col = grid[row].index([true, true])
    intersections.push([row, col])
    grid[row][col] = '+'
  end
end
puts intersections.length

closest = grid.length * 2
intersections.each do |int|
  vert = (row_o - int[0]).abs
  horiz = (col_o - int[1]).abs
  distance = vert + horiz
  closest = [closest, distance].min
end

puts closest
