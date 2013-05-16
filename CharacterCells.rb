class String
	def sort
		chars.sort.join('')
	end
	def deleteMiddle
		self[0..1] + self[-2..-1]
	end
end

def divide(string)
	first = string[0..3].sort
	second = string[4..-1].sort
	[first * 2, second * 2]
end

def add(arg, string)
	first = string[0...arg].sort
	final = string[0...arg] + first + string[arg..-1]
	final[0...8]
end

def subtract(arg, string)
	string = string[arg..-1]
	last = string[arg * -1..-1]
	final = string + last.sort
	final[0...8]
end

def union(string, string2)
	string[-4..-1].sort + string2[0..3].sort
end

def intersect(string, string2)
	string.deleteMiddle.sort + string2.deleteMiddle.sort
end

5.times do
	parts = gets.chomp.split(', ')
	command = parts[0].downcase
	string = parts[1]
	string2 = parts[2]
	string.upcase! if string
	string2.upcase! if string2
	arg = command[-1].to_i
	if command[-1] == arg.to_s
		command = command[0..-2]
	end
	case command.to_sym
	when :divide
		puts divide(string).join(' and ')
	when :add
		puts add(arg, string)
	when :subtract
		puts subtract(arg, string)
	when :union
		puts union(string, string2)
	when :intersect
		puts intersect(string, string2)
	end
end