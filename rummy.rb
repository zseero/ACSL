class Card
	attr_reader :suit, :value
	def initialize(*args)
		@Values = ['A', '2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K']
		@Suits = ['D', 'C', 'H', 'S']
		if args[0].is_a?(String)
			@value = @Values.index(args[0][0])
			@suit = @Suits.index(args[0][1])
		end
		if args[0].is_a?(Fixnum) && args[1].is_a?(Fixnum)
			@value = args[0]
			@suit = args[1]
		end
	end

	def <(c)
		if (@value == c.value)
			@suit < c.suit
		else
			@value < c.value
		end
	end
	def >(c); c < self; end
	def <=(c); self < c || self == c; end
	def >=(c); self > c || self == c; end
	def ==(c)
		return false if c.nil?
		self.value == c.value && self.suit == c.suit
	end
	def <=>(c)
		return -1 if self < c
		return 0 if self == c
		return 1 if self > c
	end

	def inRun?(c)
		dif = (@value - c.value).abs
		dif == 1 && @suit == c.suit
	end

	def inSet?(c)
		dif = (@value - c.value).abs
		dif == 0 && @suit != c.suit
	end

	def to_s
		@Values[@value] + @Suits[@suit]
	end

	def dup
		Card.new(to_s)
	end
end

class Hand
	attr_reader :runsAndSets
	def initialize(cards)
		@runsAndSets = []
		@extra = []
		cards.each do |card|
			card = Card.new(card) if card.is_a?(String)
			@extra << card if card.is_a?(Card)
		end
		calcRunsAndSets
	end

	def getARunOrSetWith(c)
		inRun = [c]
		isRun = true
		isSet = true
		@extra.each do |c2|
			bool = false
			inRun.each { |card|
				if card.inRun?(c2) && isRun && !inRun.include?(c2)
					bool = true
					isSet = false
				end
				if card.inSet?(c2) && isSet && !inRun.include?(c2)
					bool = true
					isRun = false
				end
			}
			if bool
				inRun << c2
			end
		end
		inRun
	end

	def getARunOrSet
		runOrSet = nil
		@extra.each do |c|
			run = getARunOrSetWith(c)
			if run.length >= 3
				if run.length > 4
					run = run[0...4]
				end
				runOrSet = run
				break
			end
		end
		if runOrSet
			runOrSet.each {|rs| @extra.delete(rs)}
			@runsAndSets << runOrSet
		end
	end

	def calcRunsAndSets
		newRS = []
		@runsAndSets.each { |rs|
			@extra += rs if rs.length == 3
			newRS << rs if rs.length == 4
		}
		@runsAndSets = newRS
		@extra.sort!
		prevLength = 0
		begin
			prevLength = @extra.length
			getARunOrSet
		end while prevLength != @extra.length
	end

	def play(card)
		oldExtra = @extra.dup
		card = Card.new(card) if card.is_a?(String)
		@extra << card
		calcRunsAndSets
		min = @extra.min
		min = card if @extra.length > oldExtra.length
		#puts "Card: #{card}, Deleted #{min}, Completed: #{@runsAndSets.to_s}, Extra: #{@extra.to_s}"
		bool = @extra.delete_at(@extra.index(min))
	end

	def sortButReverseSets(r)
		if r[0].inRun?(r[1])
			return r.sort
		elsif r[0].inSet?(r[1])
			return r.sort.reverse
		end
	end

	def to_s
		out = []
		rs = @runsAndSets
		if rs.length == 2
			r1 = rs[0].sort
			r2 = rs[1].sort
			order = [r1, r2] if r1.length == 4 || r1[0] < r2[0]
			order = [r2, r1] if r2.length == 4 || r2[0] < r1[0]
			order.each { |r| puts r.to_s if sortButReverseSets(r).nil?
				out += sortButReverseSets(r)}
		elsif rs.length == 1
			out += sortButReverseSets(rs[0].sort)
		end
		@extra.sort!.reverse!
		out += @extra
		out.join(', ')
	end
end

input = [
	'4H, 5H, 6H, 8C, 8S, JD, JC',
	'3H, 7H, JS, 3C, AH',
	'AH, 3D, JS, QH, 2C',
	'7H, 8H, JS, 8D, AS',
	'2C, 5D, 7S, 9H, TC',
	'3H, 7H, 8D, JS, AH'
]

startingCards = gets.chomp.split(', ')
startingCards = input[0].split(', ') if startingCards.length == 0

i = 1
5.times do
	hand = Hand.new(startingCards)
	next5 = gets.chomp.split(', ')
	next5 = input[i].split(', ') if next5.length == 0
	next5.each { |card|
		hand.play(card)
		break if hand.runsAndSets.length >= 2
	}
	puts '=> ' + hand.to_s
	i += 1
end