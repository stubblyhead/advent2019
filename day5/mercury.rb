class Intcode
  attr_reader :stack, :pointer, :input

  def initialize(stack, input)
    @stack = stack
    @pointer = 0
    @input = input
    @prev_pointer = 0
  end

  def walk
    inst = @stack[@pointer].to_s
    case inst
    when /1$/
      add(inst, *@stack[@pointer+1,3])
    when /2$/
      mult(inst, *@stack[@pointer+1,3])
    when /3$/
      input(@stack[@pointer+1])
    when /4$/
      output(inst, @stack[@pointer+1])
    when /99$/
      halt()
    end

  end


  def add(inst, a, b, dest)
    inst = inst.rjust(5,'0')
    if inst[0] == '1'
      puts "bad instruction at #{@pointer}"
      exit
    end
    a = @stack[a] if inst[-3] == '0'
    b = @stack[b] if inst[-4] == '0'
    @stack[dest] = a + b
    @prev_pointer = @pointer
    @pointer += 4
  end

  def mult(inst, a, b, dest)
    inst = inst.rjust(5, '0')
    if inst[0] == '1'
    puts "bad instruction at #{@pointer}"
    exit
  end
    a = @stack[a] if inst[-3] == '0'
    b = @stack[b] if inst[-4] == '0'
    @stack[dest] = a * b
    @prev_pointer = @pointer
    @pointer += 4
  end

  def input(dest)
    @stack[dest] = @input
    @prev_pointer = @pointer
    @pointer += 2
  end

  def output(inst, src)
    inst = inst.rjust(5, '0')
    inst[-3] == '0' ? a = @stack[src] : a = src
    puts "#{@pointer} #{a}"
    # if a != 0
    #   puts "error at #{@pointer}, instruction #{inst} for address #{src}"
    # end
    @prev_pointer = @pointer
    @pointer += 2
  end

  def halt
    puts "#{@pointer}, #{@prev_pointer}"
    exit
  end
end

inst = File.readlines('./input', :chomp=>true)[0].split(',').map { |s| s.to_i }

machine = Intcode.new(inst, 1)
while true
  machine.walk
end
