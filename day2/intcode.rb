require 'pry'
binding.pry

master = File.readlines('./input', :chomp=>true)[0].split(',').map {|s| s.to_i}
(0..99).each do |noun|
  (0..99).each do |verb|
    values = master.clone
    values[1] = noun
    values[2] = verb
    pointer = 0
    while true
      case values[pointer]
      when 1
        values[values[pointer+3]] = values[values[pointer+1]] + values[values[pointer+2]]
        pointer += 4
      when 2
        values[values[pointer+3]] = values[values[pointer+1]] * values[values[pointer+2]]
        pointer += 4
      when 99
        break
      else
#        puts "whoops something broke"
        break
      end
    end
    if values[0] == 19690720
      puts noun*100 + verb
      exit
    end
  end
end
