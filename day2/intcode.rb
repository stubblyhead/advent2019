values = File.readlines('./input', :chomp=>true)[0].split(',').map {|s| s.to_i}
#values = "1,9,10,3,2,3,11,0,99,30,40,50".split(',').map{|s| s.to_i}
values[1] = 12
values[2] = 2
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
		puts "whoops something broke"
	end
end

puts  values[0]
