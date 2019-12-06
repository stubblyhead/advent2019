# require 'pry'
# binding.pry

input = File.readlines('./input', :chomp=>true)

grid = Array.new(15000) { Array.new(15000) }
row_o = col_o = row = col = grid.length / 2

def move(grid, row, col, step, distance, wire)
  direction = step[0]
  length = step[1..-1].to_i

  case direction
  when 'U'
    length.times {
      row -= 1
      distance += 1
      if grid[row][col] == nil
        grid[row][col] = [0,0]
      end
      grid[row][col][wire] = distance unless grid[row][col][wire] > 0
      # p grid[row][col] if wire == 1
    }
  when 'D'
    length.times {
      row += 1
      distance += 1
      if grid[row][col] == nil
        grid[row][col] = [0,0]
      end
      grid[row][col][wire] = distance unless grid[row][col][wire] > 0
      # p grid[row][col] if wire == 1
    }
  when 'R'
    length.times {
      col += 1
      distance += 1
      if grid[row][col] == nil
        grid[row][col] = [0,0]
      end
      grid[row][col][wire] = distance unless grid[row][col][wire] > 0
      # p grid[row][col] if wire == 1
    }
  when 'L'
    length.times {
      col -= 1
      distance += 1
      if grid[row][col] == nil
        grid[row][col] = [0,0]
      end
      grid[row][col][wire] = distance unless grid[row][col][wire] > 0
      # p grid[row][col] if wire == 1
    }
  end
  [grid, row, col, distance]

end

wire_a = input[0]
wire_b = input[1]

distance = 0
wire_a.split(',').each do |step|
  grid, row, col, distance = move(grid, row, col, step, distance, 0)
end

row, col = [row_o, col_o]

distance = 0
wire_b.split(',').each do |step|
  grid, row, col, distance = move(grid, row, col, step, distance, 1)
end

#grid[row_o][col_o] = [0,0]
intersections = []
grid.each_index do |rownum|
  grid[rownum].each_index do |colnum|
    if grid[rownum][colnum] != nil
      if grid[rownum][colnum].min > 0
        intersections.push(grid[rownum][colnum].sum)
      end
    end
  end
end

#puts intersections.sort
puts intersections.min
