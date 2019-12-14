class Layer
  attr_reader :count, :grid
  def initialize(w, h)
    @grid = Array.new(w) { Array.new(h) }
    @count = Hash.new(0)
  end

  def populate(values)
    values = values.split('')
    @grid.each_index do |i|
      @grid[i].each_index do |j|
        val = values.shift
        @grid[i][j] = val
        @count[val] += 1
      end
    end
  end

  def to_s
    val = ''
    @grid.each do |i|
      i.each do |j|
        val += j
      end
      val += "\n"
    end
    val.gsub!('0', 'X')
    val.gsub!('1', ' ')
    val.gsub!('2', ' ')
    val
  end
end

values = File.readlines('input', :chomp=>true)[0]

layers = []
while values.length > 0
  layers.push(Layer.new(6,25))
  layers[-1].populate(values.slice!(0,150))
end

min_zero = 151
min_layer = nil
layers.each do |l|
  this_min = l.count['0']
  if this_min < min_zero
    min_zero = this_min
    min_layer = l
  end
end

puts min_layer.count['1'] * min_layer.count['2']

composite = Array.new(6) { Array.new(25) }
composite.each_index do |i|
  composite[i].each_index do |j|
    curr_layer = 0
    while true
      if layers[curr_layer].grid[i][j] != '2'
        composite[i][j] = layers[curr_layer].grid[i][j]
      else
        curr_layer += 1
      end
      break if composite[i][j]
    end
  end
end
values = ''
composite.each { |i| values += i.join }
final = Layer.new(6,25)
final.populate(values)
puts final
