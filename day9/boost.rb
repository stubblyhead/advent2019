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
    @waiting = false
    @base = 0
  end

  def run
    until @finished == true
      step
      return if @waiting
    end
  end

  def receive(val)
    @input.push(val)
  end

  def step
    inst = @stack[@pointer].to_s
    case inst
    when /99$/
      halt()
    when /1$/
      add(inst, *@stack[@pointer+1,3])
    when /2$/
      mult(inst, *@stack[@pointer+1,3])
    when /3$/
      if @input.length > 0
        @waiting = false
        input(inst, @stack[@pointer+1])
      else
        @waiting = true
      end
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
    when /9$/
      adjust(inst, stack[@pointer+1])
    end

  end


  def add(inst, a, b, dest)
    inst = inst.rjust(5,'0')
    if inst[0] == '1'
      puts "bad instruction at #{@pointer}"
      exit
    end
    case inst[-3]
    when '0'
      expand(a) if a >= @stack.length
      a = @stack[a]
    when '2'
      expand(@base + a) if @base + a >= @stack.length
      a = @stack[@base + a]
    end
    case inst[-4]
    when '0'
      expand(b) if b >= @stack.length
      b = @stack[b]
    when '2'
      expand(@base + b) if @base + b >= @stack.length
      b = @stack[@base + b]
    end
    if dest >= @stack.length
      expand(dest)
    end
    case inst[0]
    when '0'
      expand(dest) if dest >= @stack.length
      @stack[dest] = a + b
    when '2'
      expand(@base + dest) if @base + dest >= @stack.length
      @stack[@base + dest] = a + b
    end
    @pointer += 4
  end

  def mult(inst, a, b, dest)
    inst = inst.rjust(5, '0')
    if inst[0] == '1'
      puts "bad instruction at #{@pointer}"
      exit
    end
    case inst[-3]
    when '0'
      expand(a) if a >= @stack.length
      a = @stack[a]
    when '2'
      expand(@base + a) if @base + a >= @stack.length
      a = @stack[@base + a]
    end
    case inst[-4]
    when '0'
      expand(b) if b >= @stack.length
      b = @stack[b]
    when '2'
      expand(@base + b) if @base + b >= @stack.length
      b = @stack[@base + b]
    end
    case inst[0]
    when '0'
      expand(dest) if dest >= @stack.length
      @stack[dest] = a * b
    when '2'
      expand(@base + dest) if @base + dest >= @stack.length
      @stack[@base + dest] = a * b
    end
    @pointer += 4
  end

  def input(inst, dest)
    inst = inst.rjust(5, '0')
    case inst[-3]
    when '0'
      expand(dest) if dest >= @stack.length
      @stack[dest] = @input.shift
    when '2'
      expand(@base + dest) if @base + dest >= @stack.length
      @stack[@base + dest] = @input.shift
    end
    @pointer += 2
  end

  def output(inst, src)
    inst = inst.rjust(5, '0')
    case inst[-3]
    when '0'
      a = @stack[src]
    when '1'
      a = src
    when '2'
      a = @stack[@base + src]
    end
    @out = a
    @pointer += 2
  end

  def jump_if_true(inst, val, dest)
    inst = inst.rjust(5, '0')
    case inst[-3]
    when '0'
      expand(val) if val >= @stack.length
      val = @stack[val]
    when '2'
      expand(@base + val) if @base + val >= @stack.length
      val = @stack[@base + val]
    end
    case inst[-4]
    when '0'
      expand(dest) if dest >= @stack.length
      dest = @stack[dest]
    when '2'
      expand(@base + dest) if @base + dest >= @stack.length
      dest = @stack[@base + dest]
    end
    if val == 0  #value is zero, so continue to next instr as normal
      @pointer += 3
    else  #value is not zero, so jump
      @pointer = dest
    end
  end

  def jump_if_false(inst, val, dest)
    inst = inst.rjust(5, '0')
    case inst[-3]
    when '0'
      expand(val) if val > @stack.length
      val = @stack[val]
    when '2'
      expand(@base + val) if @base + val >= @stack.length
      val = @stack[@base + val]
    end
    case inst[-4]
    when '0'
      expand(dest) if dest >= @stack.length
      dest = @stack[dest]
    when '2'
      expand(@base + dest) if @base + dest >= @stack.length
      dest = @stack[@base + dest]
    end
    if val == 0  #value is zero, so jump
      @pointer = dest
    else  #value is not zero, so continue to next instr as normal
      @pointer += 3
    end
  end

  def lt(inst, a, b, dest)
    inst = inst.rjust(5,'0')
    case inst[-3]
    when '0'
      expand(a) if a >= @stack.length
      a = @stack[a]
    when '2'
      expand(@base + a) if @base + a >= @stack.length
      a = @stack[@base + a]
    end
    case inst[-4]
    when '0'
      expand(b) if b >= @stack.length
      b = @stack[b]
    when '2'
      expand(@base + b) if @base + b >= @stack.length
      b = @stack[@base + b]
    end
    case inst[0]
    when '0'
      expand(dest) if dest >= @stack.length
      a < b ? @stack[dest] = 1 : @stack[dest] = 0
    when '2'
      expand(@base + dest) if @base + dest >= @stack.length
      a < b ? @stack[@base + dest] = 1 : @stack[@base + dest] = 0
    end
    @pointer += 4
  end

  def eq(inst, a, b, dest)
    inst = inst.rjust(5,'0')
    case inst[-3]
    when '0'
      expand(a) if a >= @stack.length
      a = @stack[a]
    when '2'
      expand(@base + a) if @base + a >= @stack.length
      a = @stack[@base + a]
    end
    case inst[-4]
    when '0'
      expand(b) if b >= @stack.length
      b = @stack[b]
    when '2'
      expand(@base + b) if @base + b >= @stack.length
      b = @stack[@base + b]
    end
    case inst[0]
    when '0'
      expand(dest) if dest >= @stack.length
      a == b ? @stack[dest] = 1 : @stack[dest] = 0
    when '2'
      expand(@base + dest) if @base + dest >= @stack.length
      a == b ? @stack[@base + dest] = 1 : @stack[@base + dest] = 0
    end
    @pointer += 4
  end

  def adjust(inst, offset)
    inst = inst.rjust(5,'0')
    case inst[-3]
    when '0'
      val = @stack[offset]
    when '1'
      val = offset
    when '2'
      val = @stack[@base + offset]
    end
    @base += val
    @pointer += 2
  end

  def halt
    @finished = true
  end

  def successful?
    @finished
  end

  def expand(new_max)
    @stack = @stack + Array.new(new_max - @stack.length + 1 ) { 0 }
  end
end

list = File.readlines('input')[0].split(',').map { |s| s.to_i }
sensors = Intcode.new(list.dup, [1])
sensors.run
puts sensors.out

sensors = Intcode.new(list.dup, [2])
sensors.run
puts sensors.out
