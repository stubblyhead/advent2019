require 'pry'
binding.pry

class Planet
  attr_reader :parent, :children, :orbit_count

  def initialize(name, parent=nil)
    @parent = parent
    @children = []
    @name = name
    if @parent
      @parent.add_child(self)
      @orbit_count = @parent.orbit_count + 1
    else
      @orbit_count = 0
    end
  end

  def add_child(child)
    @children.push(child)
  end

end

orrery = {}

list = File.readlines('./input', :chomp=>true)

def traverse(list, system, planet, parent)
  system[planet] = Planet.new(planet, parent)
  children_pairs = list.filter { |i| /^#{planet}/.match(i) }
  children = children_pairs.map { |i| /\)(.*)/.match(i)[1] }
  children.each { |i| traverse(list, system, i, system[planet]) }
end

total_orbits = 0

traverse(list, orrery, 'COM', nil)

orrery.values.each { |i| total_orbits += i.orbit_count }

puts total_orbits
