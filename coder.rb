class MsgKey
	attr_accessor :msg, :key
	def initialize(msg, key)
		@msg = msg
		@key = key
	end
end

$alphabet = [' ', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
	'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '.', ',', '\'', '"', '!',
	'@', '#', '$', '%', '^', '&', '*', '(', ')', '/', '\\', '<', '>', ':', ';', '[', ']',
	'|', '-', '_', '+', '=', '?', '1', '2', '3', '4', '5', '6', '7', '8', '9']

#$alphabet = [' ', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.', ',', '\'', '"']

def findMaxExp(key)
	i = 0
	while true
		foo = key ** i
		return i - 1 if foo >= $alphabet.length
		i += 1
	end
end

def decode(msg, key)
	l = findMaxExp(key)
	result = ""
	i = 0
	while i < msg.length
		bits = []
		(l + 1).times do
			bits << msg[i]
			i += 1
		end
		num = 0
		ii = l
		for bit in bits
			num += (bit.to_i * (key ** ii))
			ii -= 1
		end
		char = $alphabet[num]
		result += char if !char.nil?
	end
	return result
end

def encode(msg, key)
	l = findMaxExp(key)
	result = ""
	for c in msg.split(//)
		c.downcase!
		index = $alphabet.index(c)
		remainder = index.to_i
		ii = l
		while ii >= 0
			ckey = key ** ii
			result += (remainder / ckey).to_s
			remainder = remainder % ckey
			ii -= 1
		end
	end
	return result
end

def ask(prompt)
	puts prompt
	message = gets.chomp
	key = nil
	if message.length > 0
		while true
			printf "Key: "
			key = gets.chomp.to_i
			if key < 2 || key > 10
				puts "Invalid key, valid key range: 2-10 (inclusive)"
			else
				break
			end
		end
		return MsgKey.new(message, key)
	end
	nil
end

mk = ask ("Message to be decoded:")
puts decode(mk.msg, mk.key) if !mk.nil?
mk = ask ("Message to be encoded:")
puts encode(mk.msg, mk.key) if !mk.nil?