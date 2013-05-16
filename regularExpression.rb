class String
	def magicSplit
		parts = []
		sofar = []
		split('').each do |c|
			sofar << c
			if c == '*'
				parts << sofar.join('') if sofar.length > 0
				sofar = []
			elsif sofar[0] != '(' && c.to_i.to_s == c && sofar.length > 1
				s = sofar[0..-2]
				parts << s.join('') if s.length > 0
				parts << c
				sofar = []
			end
		end
		parts << sofar.join('') if sofar.length > 0
		parts
	end
end

def inner(exp, input)
	len = input.length
	len.times do |i|
		ii = len - 1 - i
		s = input[0..(ii)]
		result = eval("/#{exp}/.match(\'#{s}\')")
		return ii + 1 if result.to_s == s
	end
	0
end

def outer(exp, input)
	results = []
	exps = []
	split = exp.magicSplit
	# puts "o:#{exp}, #{split.join(', ')}"
	len = split.length
	len.times do |i|
		ii = len - 1 - i
		s = split[0..(ii)]
		exps << s.join('')
	end
	exps.each do |e|
		r = inner(e, input)
		# puts "#{e}, #{input}, #{r}"
		return 'YES' if exps.index(e) == 0 && r == input.length
		results << r
	end
	results.max
end

def union(exp, input)
	results = []
	exp.split('U').each do |e|
		e = e[1..-2] if e[-1] == ')'
		results << outer(e, input)
	end
	return 'Yes' if results.include?('YES')
	'No, ' + results.max.to_s
end

10.times do
	input = gets.chomp.split(' ')
	puts union(input[0], input[1])
end