class Planet
  attr_reader :parent, :children, :orbit_count

  def initialize(parent=nil)
    @parent = parent
    @children = []
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

list = File.open('./input', :chomp=>true)

def travel(planet, parent, system, list)
  # parent_pair = system.filter { |x| /#{planet}$/.match(x) }
  # if parent_pair.length == 0
  #   parent = nil
  # else
  #   parent = parent_pair.split(')')[0]
  # end
  children_pairs = system.filter { |x| /^#{planet}/.match(x) }
  if children_pairs.length == 0
    children = nil
  else
    children = children_pairs.map { |x| x.match(/.{3}$/) }
  end
