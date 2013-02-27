class String
	def multiSplit symbols = ['(', ')', ',', ' ', '.']
		input = self
		nums = []
		i = 0
		while i < input.length
			token = ''
			for ii in i..(input.length - 1)
				c = input[ii]
				break if symbols.include?(c)
				token += c
				i = ii
			end
			if token != ''
				nums << token
			end
			i += 1
		end
		nums
	end
end

class Float
	def to_dollar
		a = round(2).to_s
		a += '0' if a.index('.') == a.length - 2
		'$' + a
	end
end

class Day
	attr_accessor :start, :finish

	def initialize(start, finish)
		@code = ['1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H']
		@start = start
		@finish = finish
	end

	def totalHours
		(@code.index(@finish) - @code.index(@start)).to_f / 2
	end
end

class Week
	attr_accessor :location, :days

	def initialize(string)
		parts = string.multiSplit
		raise "Input incorrect" if parts.length.even?
		@location = parts[0].to_i
		@days = []
		i = 1
		while i < parts.length
			@days << Day.new(parts[i], parts[i + 1])
			i += 2
		end
	end

	def totalEarned
		a = standardPerHour(10, 15, 30) if (100..199).include?(@location)
		a = standardPerHour(7.5, 15, 40) if (200..299).include?(@location)
		a = standardPerHour(9.25, 10.5, 20) if (300..399).include?(@location)
		a = extraWeekend(6.75, 13.5, [0, 6]) if (400..499).include?(@location)
		a = overTimeByDay(8, 12, 6) if (500..599).include?(@location)
		a
	end

	def overTimeCalc(hours, perHour, perOver, hoursTillOver)
		if hours >= hoursTillOver
			overTime = hours - hoursTillOver
			return (perHour * hoursTillOver) + (overTime * perOver)
		else
			return hours * perHour
		end
	end

	def standardPerHour(perHour, perOver, hoursTillOver)
		hours = 0
		for day in @days
			hours += day.totalHours
		end
		overTimeCalc(hours, perHour, perOver, hoursTillOver)
	end

	def overTimeByDay(perHour, perOver, hoursTillOver)
		a = 0
		for day in @days
			a += overTimeCalc(day.totalHours, perHour, perOver, hoursTillOver)
		end
		a
	end

	def extraWeekend(perHour, perWeekend, weekendIndexes)
		days = @days.dup
		a = 0
		for weekend in weekendIndexes.sort.reverse
			hours = days[weekend].totalHours
			a += hours * perWeekend
			days.delete_at(weekend)
		end
		for day in days
			a += day.totalHours * perHour
		end
		a
	end
end

5.times do
	puts Week.new(gets.chomp).totalEarned.to_dollar
end