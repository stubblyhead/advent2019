require 'pry'
binding.pry

#grid = File.readlines('input', :chomp=>true).map { |s| s.split('') }

grid =
".#..#
.....
#####
....#
...##".lines(:chomp=>true).map{|s| s.split('') }

asteroids = {}
grid.each_index do |row|
  grid[row].each_index do |col|
    next if grid[row][col] == '.'
    asteroids[[row,col]] = []
    grid.each_index do |i|
      grid[i].each_index do |j|
        next if i == row and j == col
        next if grid[i][j] == '.'
        if j == col
          asteroids[[row,col]].push((row - i) * Float::INFINITY)
        elsif j > col
          m = ((i - row).to_f/(j - col))
        else
          m = ((row - i).to_f/(col-j))
        end
        if i > row
          asteroids[[row,col]].push([m,:right])
        else
          asteroids[[row,col]].push([m,:left])
        end
      end
    end
  end
end
max_asteroids = 0
asteroids.values.each { |i| max_asteroids = [max_asteroids, i.uniq.length] }

puts max_asteroids
