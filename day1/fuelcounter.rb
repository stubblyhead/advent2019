lines = File.readlines('./input', :chomp=>true)
fuel = 0
lines.each do |i|
	mod_mass = i.to_i
	mod_fuel = [((mod_mass / 3) - 2)]
	while true
		mod_fuel.push(((mod_fuel[-1] /3) -2))
		if mod_fuel[-1] <= 0
			mod_fuel.pop
			break
		end
	end
	fuel += mod_fuel.sum 

end

puts fuel
