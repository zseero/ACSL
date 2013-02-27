class Array
	def specialJoin(basekey)
		r = []
		for i in 0..(basekey.length - 1)
			rr = ""
			(basekey[i].to_s.length - 1).times do
				rr += ' '
			end
			rr += self[i].to_s
			r << rr
		end
		r.join(' ')
	end
end

def nExit
	puts
	exit
end

require_relative 'basetranslate.rb'
include Base

printf "Base: "
base = gets.chomp.to_i
printf "Digits: "
digits = gets.chomp.to_i
basekey = []
for i in 0..(digits - 1)
	basekey.insert(0, base ** i)
end
puts basekey.join('|')

i = 0
while true
	bnry = encode(i, base).split(//)
	nExit if bnry.length > digits
	if bnry.length < digits
		(digits - bnry.length).times do
			bnry.insert(0, 0)
		end
	end
	printf "\r#{bnry.specialJoin(basekey)} [#{i}]"
	i += 1
	sleep 1
end