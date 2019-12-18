require 'pry'
binding.pry

grid = File.readlines('input', :chomp=>true).map { |s| s.split('') }

asteroids = {}
grid.each_index do |row|
  grid[row].each_index do |col|
    next if grid[row][col] == '.'
    asteroids[[row,col]] = []
    grid.each_index do |t_row|
      grid[t_row].each_index do |t_col|
        next if t_row == row and t_col == col
        next if grid[t_row][t_col] == '.'
        if t_col == col
          asteroids[[row,col]].push([(row - t_row) * Float::INFINITY,:infinite,t_row, t_col])
          next
        elsif t_col > col
          m = ((t_row - row).to_f/(t_col - col))
        else
          m = ((row - t_row).to_f/(col - t_col))
        end
        if t_col > col
          asteroids[[row,col]].push([m,:right,t_row,t_col])
        else
          asteroids[[row,col]].push([m,:left,t_row,t_col])
        end
      end
    end
  end
end
max_asteroids = 0
station = nil
asteroids.keys.each do |i|
  uniq_slopes = asteroids[i].map { |i| i[0,2] }.uniq.length
  max_asteroids = [max_asteroids, uniq_slopes].max
  station = i if max_asteroids == uniq_slopes
end
puts max_asteroids
