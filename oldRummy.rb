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
	def initialize(cards)
		@runsAndSets = []
		@extra = []
		cards.each do |card|
			card = Card.new(card) if card.is_a?(String)
			@extra << card if card.is_a?(Card)
		end
		calcRunsAndSets
	end

	def inRunWithRunsAndSets(c)
		@runsAndSets.each do |runOrSet|
			if runOrSet.length < 4 && !runOrSet.include?(c)
				run = runOrSet[0].inRun?(runOrSet[1])
				runOrSet.each do |c2|
					if c.inRun?(c2) && run || c.inSet?(c2) && !run
						return [c, @runsAndSets.index(runOrSet)]
					end
				end
			end
		end
		nil
	end

	def inRunWithExtra(c)
		@extra.each do |c2|
			if c.inRun?(c2) || c.inSet?(c2)
				return [c, c2]
			end
		end
		nil
	end

	def calcWithRunsAndSets
		inRun = nil
		@extra.each do |c|
			result = inRunWithRunsAndSets(c)
			if result
				inRun = result
				break
			end
		end
		if inRun
			@extra.delete(inRun[0])
			@runsAndSets[inRun[1]] << inRun[0]
		end
	end

	def calcWithExtra
		inRun = nil
		@extra.each do |c|
			result = inRunWithExtra(c)
			if result
				inRun = result
				break
			end
		end
		if inRun
			@extra.delete(inRun[0])
			@extra.delete(inRun[1])
			@runsAndSets << inRun
		end
	end

	def calcRunsAndSets
		prevLength = 0
		begin
			prevLength = @extra.length
			calcWithRunsAndSets
			calcWithExtra
		end while prevLength != @extra.length
	end

	def getLeftOver
		leftOver = @extra.dup
		@runsAndSets.each {|runOrSet| leftOver += runOrSet if runOrSet.length < 3}
		leftOver
	end

	def getFullRunsAndSets
		fulls = []
		@runsAndSets.each {|runOrSet| fulls << runOrSet if runOrSet.length >= 3}
		fulls
	end

	def play(card)
		oldExtra = @extra.length
		card = Card.new(card) if card.is_a?(String)
		@extra << card
		calcRunsAndSets
		leftOver = getLeftOver
		min = leftOver.min
		min = card if oldExtra < @extra.length
		bool = @extra.delete(min)
		if !bool
			deletions = []
			@runsAndSets.map! { |runOrSet|
				runOrSet.delete(min)
				if runOrSet.length == 1
					@extra << runOrSet[0]
					deletions << @runsAndSets.index(runOrSet)
				end
				runOrSet
			}
			i = 0
			deletions.each {|d| @runsAndSets.delete_at(d - i)}
		end
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
		rs = getFullRunsAndSets
		if rs.length == 2
			r1 = rs[0].sort
			r2 = rs[1].sort
			order = [r1, r2] if r1.length == 4 || r1[0] < r2[0]
			order = [r2, r1] if r2.length == 4 || r2[0] < r1[0]
			order.each { |r| out += sortButReverseSets(r)}
		elsif rs.length == 1
			out += sortButReverseSets(rs[0].sort)
		end
		leftOver = getLeftOver
		leftOver.sort!.reverse!
		out += leftOver
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
		break if hand.getFullRunsAndSets.length >= 2
	}
	puts '=> ' + hand.to_s
	i += 1
end