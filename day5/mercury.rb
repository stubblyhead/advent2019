require 'pry'
binding.pry

class Intcode
  attr_reader :stack, :pointer, :input

  def initialize(stack, input)
    @stack = stack
    @pointer = 0
    @input = input
    @prev_pointer = 0
    @finished = false
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
    when /5$/
      jump_if_true(inst, *@stack[@pointer+1,2])
    when /6$/
      jump_if_false(inst, *@stack[@pointer+1,2])
    when /7$/
      lt(inst, *@stack[@pointer+1,3])
    when /8$/
      eq(inst, *@stack[@pointer+1,3])
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
    @prev_pointer = @pointer
    @pointer += 2
  end

  def jump_if_true(inst, val, dest)
    inst = inst.rjust(5, '0')
    val = @stack[val] if inst[-3] == '0'
    if val == 0
      @pointer += 3
    else
      @pointer = val
    end
  end

  def jump_if_false(inst, val, dest)
    inst = inst.rjust(5, '0')
    val = @stack[val] if inst[-3] == '0'
    if val == 0
      @pointer = val
    else
      @pointer += 3
    end
  end

  def lt(inst, a, b, dest)
    inst = inst.rjust(5,'0')
    a = @stack[a] if inst[-3] == '0'
    b = @stack[a] if inst[-4] == '0'
    a < b ? @stack[dest] = 1 : @stack[dest] = 0
    @pointer += 4
  end

  def eq(inst, a, b, dest)
    inst = inst.rjust(5,'0')
    a = @stack[a] if inst[-3] == '0'
    b = @stack[a] if inst[-4] == '0'
    a == b ? @stack[dest] = 1 : @stack[dest] = 0
    @pointer += 4
  end

  def halt
    puts "#{@pointer}, #{@prev_pointer}"
    @finished = true
  end

  def successful?
    @finished
  end
end

inst = File.readlines('./input', :chomp=>true)[0].split(',').map { |s| s.to_i }

air_conditioner = Intcode.new(inst, 1)
until air_conditioner.successful?
  air_conditioner.walk
end

thermal_radiator = Intcode.new(inst, 5)
until thermal_radiator.successful?
  thermal_radiator.walk
end
