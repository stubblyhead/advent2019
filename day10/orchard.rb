# require 'pry'
# binding.pry

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
          asteroids[[row,col]].push((row - t_row) * Float::INFINITY)
          next
        elsif t_col > col
          m = ((t_row - row).to_f/(t_col - col))
        else
          m = ((row - t_row).to_f/(col - t_col))
        end
        if t_col > col
          asteroids[[row,col]].push([m,:right])
        else
          asteroids[[row,col]].push([m,:left])
        end
      end
    end
  end
end
max_asteroids = 0
asteroids.values.each { |i| max_asteroids = [max_asteroids, i.uniq.length].max }

puts max_asteroids
