require 'pry'
binding.pry

class Layer
  attr_reader :count
  def initialize(w, h)
    @grid = Array.new(w) { Array.new(h) }
    @count = Hash.new(0)
  end

  def populate(values)
    values = values.split('')
    @grid.map! do |i|
      i.map! do |j|
        j = values.shift
        @count[j] += 1
      end
    end
  end
end

values = File.readlines('input', :chomp=>true)[0]

layers = []
while values.length > 0
  layers.push(Layer.new(25,6))
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
