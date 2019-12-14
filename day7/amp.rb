# require 'pry'
# binding.pry

class Intcode
  attr_reader :stack, :pointer, :input, :out

  def initialize(stack, input)
    @stack = stack.dup
    @pointer = 0
    @input = input
    @prev_pointer = 0
    @finished = false
  end

  def run
    until @finished == true
      step
    end

  end

  def step
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
    @pointer += 4
  end

  def input(dest)
    @stack[dest] = @input.shift
    @pointer += 2
  end

  def output(inst, src)
    inst = inst.rjust(5, '0')
    inst[-3] == '0' ? a = @stack[src] : a = src
    @out = a
    @pointer += 2
  end

  def jump_if_true(inst, val, dest)
    inst = inst.rjust(5, '0')
    val = @stack[val] if inst[-3] == '0'
    dest = @stack[dest] if inst[-4] == '0'
    if val == 0  #value is zero, so continue to next instr as normal
      @pointer += 3
    else  #value is not zero, so jump
      @pointer = dest
    end
  end

  def jump_if_false(inst, val, dest)
    inst = inst.rjust(5, '0')
    val = @stack[val] if inst[-3] == '0'
    dest = @stack[dest] if inst[-4] == '0'
    if val == 0  #value is zero, so jump
      @pointer = dest
    else  #value is not zero, so continue to next instr as normal
      @pointer += 3
    end
  end

  def lt(inst, a, b, dest)
    inst = inst.rjust(5,'0')
    a = @stack[a] if inst[-3] == '0'
    b = @stack[b] if inst[-4] == '0'
    a < b ? @stack[dest] = 1 : @stack[dest] = 0
    @pointer += 4
  end

  def eq(inst, a, b, dest)
    inst = inst.rjust(5,'0')
    a = @stack[a] if inst[-3] == '0'
    b = @stack[b] if inst[-4] == '0'
    a == b ? @stack[dest] = 1 : @stack[dest] = 0
    @pointer += 4
  end

  def halt
    @finished = true
  end

  def successful?
    @finished
  end
end

input = File.readlines('./input', :chomp => true)[0].split(',').map { |s| s.to_i }

max_signal = 0
settings = (0..4).to_a.permutation.each do |perm|
  input_signal = 0
  5.times {
    amp = Intcode.new(input.dup, [perm.shift, input_signal])
    amp.run
    input_signal = amp.out
  }
  max_signal = [input_signal, max_signal].max
end

puts max_signal
