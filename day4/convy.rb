candidates = (124075..580769)
dupes = []
valid = []

# collect all numbers with at least one consecutive duplicate digit
candidates.each do |i|
  i = i.to_s
  dupes.push(i) if /.*(.)\1.*/.match(i)
end

# collect all numbers from dupes[] that are equal to themselves after sorting digits in ascending order
dupes.each do |i|
  valid.push(i) if i.split('').sort.join == i
end

puts valid.length
