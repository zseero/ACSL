class NilClass
	def to_s
		'NONE'
	end
end

class Coord
	attr_accessor :x, :y
	def initialize x, y
		@x = x
		@y = y
	end

	def to_s
		"#{@x + 1}, #{@y + 1}"
	end

	def valid?(size)
		b1 = (@x < size)
		b2 = (@y < size)
		b3 = (@x >= 0)
		b4 = (@y >= 0)
		(b1 && b2 && b3 && b4)
	end

	def copy
		Coord.new(@x, @y)
	end
end

class Square
	attr_accessor :isPiece, :count, :loc
	def initialize loc
		@loc = loc
		@isPiece = false
		@count = 0
	end
end

class Board
	attr_reader :maxDist
	def initialize pieces, size = 8
		@maxDist = nil
		@size = size
	  @pieces = pieces
	  @pieces = parseInput(pieces) if pieces.is_a?(String)
		@ary = []
		for x in 0...@size
			miniAry = []
			for y in 0...@size
				miniAry << Square.new(Coord.new(x, y))
			end
			@ary << miniAry
		end
		for piece in @pieces
			@ary[piece.x][piece.y].isPiece = true
		end
	end
	
	def parseInput(input)
	  nums = input.split(', ')
	  if nums.length.odd?
	  	@maxDist = nums[-1].to_i
	  	nums.delete_at(-1)
	  end
	  coords = []
  	i = 0
  	while i < nums.length
	  	x = nums[i].to_i - 1
	  	i += 1
		  y = nums[i].to_i - 1
		  i += 1
		  coord = Coord.new(x, y)
		  coords << coord if coord.valid? @size
	  end
	  coords
  end

	def get(coord)
		square = @ary[coord.x][coord.y]
		b1 = (square.loc.x == coord.x && square.loc.y == coord.y)
		if !b1
			puts "Accessing #{coord.x}, #{coord.y}; it has record of #{square.loc.x}, #{square.loc.y}"
		end
		square
	end

	def each
		each! do |square|
			yield(square)
			nil
		end
	end

	def each!
		for x in 0...@size
			for y in 0...@size
				square = @ary[x][y]
				newSquare = yield(square)
				square = newSquare if !newSquare.nil?
			end
		end
	end

	def resetCounts
		each! do |square|
			square.count = 0
			square
		end
	end

	def findLowestQueenLoc
		resetCounts
		incrementCapturePointsForEachPiece
		capturePoints = findAllQueenLocs
		lowestQueenLoc = getLowestCoord(capturePoints)
	end

	def getLowestCoord(coords)
		if coords.length > 0
			least = coords[0]
			for i in 1...coords.length
				coord = coords[i]
				b1 = (coord.x < least.x)
				b2 = (coord.x == least.x && coord.y < least.x)
				if b1 || b2
					least = coord
				end
			end
			least
		else
			nil
		end
	end

	def findAllQueenLocs
		capturePoints = []
		each do |square|
			if !square.isPiece
				capturePoints << square.loc if square.count == @pieces.count
			end
		end
		capturePoints
	end

	def findSurvivableSquares()
		#assuming the pieces are actually queens themselves
		resetCounts
		incrementCapturePointsForEachPiece
		safeCount = 0
		each do |square|
			safeCount += 1 if square.count == 0 && !square.isPiece
		end
		safeCount
	end

	def incrementCapturePointsForEachPiece
		for piece in @pieces
			incrementEachAxis(piece)
		end
	end

	def incrementEachAxis(coord)
		range = (-1)..(1)
		for x in range
			for y in range
				incrementSquaresByFactor(coord.copy, x, y)
			end
		end
	end

	def incrementSquaresByFactor(coord, x, y)
		n = @maxDist
		n = @size ** 2 if n.nil?
		i = 0
		if !(x == 0 && y == 0)
			begin
				i += 1
				square = get(coord)
				square.count += 1 if !square.isPiece
				coord.x += x
				coord.y += y
			end while coord.valid?(@size) && i <= n
		end
	end

	def to_s
		strings = []
		for y in 0...@size
			miniStrings = []
			for x in 0...@size
				char = @ary[x][y].count
				char = '#' if @ary[x][y].isPiece
				miniStrings << char
			end
			s = miniStrings.join(' ')
			strings << s
		end
		strings.reverse.join("\n")
	end
end

5.times do
	input = gets.chomp
	board = Board.new(input)
	bool = board.maxDist.nil?
	output = board.findLowestQueenLoc if bool
	output = board.findSurvivableSquares if !bool
	puts board.to_s
	puts output.to_s
end