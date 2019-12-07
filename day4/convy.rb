require 'pry'
binding.pry
candidates = (124075..580769)
dupes = []
valid = []
valider = []

# collect all numbers with at least one consecutive duplicate digit
candidates.each do |i|
  i = i.to_s
  dupes.push(i) if /(\d)\1/.match(i)
end


# collect all numbers from dupes[] that are equal to themselves after sorting digits in ascending order
dupes.each do |i|
  valid.push(i) if i.split('').sort.join == i
end

puts valid.length

# prune out entries with only groups of 3+
valid.each do |i|
  i.gsub!(/(\d)\1{2,}/, 'X')
  valider.push(i) if /(\d)\1/.match(i)
end

puts valider.length
