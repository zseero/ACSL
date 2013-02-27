module Base
	class Num
		attr_accessor :base
	
		def initialize base
			@alphabet = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']
			if base.is_a?(String)
				@base = base
			elsif base.is_a?(Array)
				@base = ''
				for b in base
					if b >= 10
						@base += @alphabet[b - 10]
					else
						@base += b.to_s
					end
				end
			elsif base.is_a?(Fixnum)
				@base = base.to_s
			end
			@base.sub!(/^0*/, '')
		end
	
		def parts
			parts = []
			for c in base.split(//)
				num = c.to_i
				if num.to_s == c
					parts << num 
				else
					parts << @alphabet.index(c) + 10
				end
			end
			parts
		end
	
		def to_s
			@base
		end
	end
	
	def findMaxExp(input, key)
		i = 0
		while true
			foo = key ** i
			if foo >= input
				return i
			end
			i += 1
		end
	end
	
	def decode(input, base)
		bits = input.parts
		num = 0
		ii = bits.length - 1
		for bit in bits
			num += (bit.to_i * (base ** ii))
			ii -= 1
		end
		num
	end
	
	def encode(input, tobase)
		result = []
		remainder = input
		ii = findMaxExp(input, tobase)
		while ii >= 0
			key = tobase ** ii
			result << remainder / key
			remainder = remainder % key
			ii -= 1
		end
		Num.new(result).base
	end
	
	def trans(input, base, tobase)
		puts "Base #{base}: #{input}"
		baseTen = decode(input, base)
		puts "Base 10: #{baseTen}"
		result = encode(baseTen, tobase)
		puts "Base #{tobase}: #{result}"
	end
end

if __FILE__ == $0
	include Base
	lbreak = '-------------------------'
	puts lbreak
	printf 'Number to be converted: '
	input = Num.new(gets.chomp)
	printf 'Current Base: '
	base = gets.chomp.to_i
	printf 'Output Base: '
	tobase = gets.chomp.to_i
	puts lbreak
	trans(input, base, tobase)
	puts lbreak
end