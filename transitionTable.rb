class Table
	def initialize(list)
		@ary = []
		list[1..-1].each do |item|
			@ary << [item[0].to_i, item[1].to_i]
		end
		puts @ary.inspect
	end

	def getDests(row, i)
		dests = []
		row.each do |r|
			dests << r if r != 0 && r != i + 1
		end
		dests
	end

	def getPath(path = [], i = 0)
		row = @ary[i]
		dests = getDests(row, i)
		results = []
		dests.each do |d|
			p = path.dup
			p << d
			if d == i + 1
				results << p
			else
				results += getPath(p, d - 1)
			end
		end
		results << path if results == []
		results
	end

	def getRegex(path)
		out = []
		i = 0
		path.length.times do |index|
			p = path[index]
			s = ''
			if @ary[i][0] == i + 1
				s += 'a*'
			elsif @ary[i][1] == i + 1
				s += 'b*'
			end

			if @ary[i][0] == p
				s += 'a'
			elsif @ary[i][1] == p
				s += 'b'
			else
				s += '!'
			end
			out << s
			puts "#{i}, #{p}"
			i = p - 1
		end
		out.join('')
	end
end

10.times do
	table = Table.new(gets.chomp.split(', '))
	paths = table.getPath
	puts paths.inspect
	out = []
	paths.each {|path| out << table.getRegex(path)}
	puts out.join(' OR ')
end