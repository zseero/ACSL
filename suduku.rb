#!/usr/bin/env ruby

class Coordinate
  attr_accessor :y
  attr_accessor :x

  def initialize(y, x)
    @y = y
    @x = x
  end
end

class Box
  attr_accessor :box

  def initialize(box)
    @box = box
    @length = 9
  end
  
  def getColumn(x)
    column = []
    for y in 0..8
      column << @box[y][x]
    end
    column
  end
  
  def getRow(y)
    row = []
    for x in 0..8
      row << @box[y][x]
    end
    row
  end
  
  def getSquare(zy, zx)
    square = []
    for y in 0..2
      for x in 0..2
        newy = y + roundDown(zy)
        newx = x + roundDown(zx)
        square << @box[newy][newx]
      end
    end
    square
  end
  
  def roundDown(i)
    num = (i.to_f / 3) - 0.4
    num = num.round
    num * 3
  end
  
  def actuals(input, output)
    for i in input
      if (actual(i) && !output.include?(i))
        output << i
      end
    end
    if (output.length >= @length)
      output.clear
    end
    output
  end
  
  def actual(i)
    if (i > 0 && i <= @length)
      return true
    else
      return false
    end
  end
  
  def getNext()
    max = nil
    maxhints = 0
    for y in 0..8
      for x in 0..8
        i = @box[y][x]
        if (!actual(i))
          hints = []
          hints = actuals(getRow(y), hints)
          hints = actuals(getColumn(x), hints)
          hints = actuals(getSquare(y, x), hints)
          myhints = hints.length
          if (myhints > maxhints || max.nil?)
            max = Coordinate.new(y, x)
            maxhints = myhints
          end
        end
      end
    end
    max
  end
  
  def print()
    s = ""
    for y in 0..8
      t = ""
      for x in 0..8
        t += @box[y][x].to_s
        if (x < @length)
          t += " "
        end
      end
      s += t
      if (y < @length)
        s += "\n"
      end
    end
    s
  end
end

class Solver
  attr_accessor :data
  attr_accessor :nums

  def initialize(box)
    @nums = []
    for i in 1..9
        @nums << i
    end
    box.each do |i|
      if i.length != 9
        raise "User Error"
      end
    end
    if box.length != 9
      raise "User Error"
    end
    @data = Box.new(box)
  end

  def getPossibles(current, d)
    possibles = @nums.dup
    for t in d.getColumn(current.x)
      if possibles.include?(t)
        possibles.delete(t)
      end
    end
    for t in d.getRow(current.y)
      if possibles.include?(t)
        possibles.delete(t)
      end
    end
    for t in d.getSquare(current.y, current.x)
      if possibles.include?(t)
        possibles.delete(t)
      end
    end
    possibles
  end

  def msolve(current, d)
    possibles = getPossibles(current, d)
    possibles.each do |c|
      d.box[current.y][current.x] = c
      nextOne = d.getNext()
      if (nextOne.nil?)
        return d
      end
      system("cls")
      puts d.print
      result = msolve(nextOne, d.dup)
      if (!result.nil?)
        return result
      end
    end
    nil
  end

  def solve()
    if !validize
      return nil
    end
    nextOne = @data.getNext()
    if nextOne.nil?
      return @data
    end
    result = msolve(nextOne, data.dup)
  end

  def validize()
    if @data.box.length != 9
      return false
    end
    for y in 0..8
      if @data.box[y].length != 9
        return false
      end
      for x in 0..8
        i = @data.box[y][x]
        if i != 0
          c = Coordinate.new(y, x)
          d = @data.dup
          d.box[y][x] = 0
          possibles = getPossibles(c, d)
          if !possibles.include?(i)
            return false
          end
        end
      end
    end
    true
  end
end

if __FILE__ == $0
  system("cls")
  box = []
  for i in 0..8
    minibox = []
    printf (i + 1).to_s + ". "
    s = gets.chomp
    s = s.split(" ")
    if s.length != 9
      puts "User Error, Replace and Continue"
      exit
    end
    s.each do |j|
      minibox << j.to_i
    end
    box << minibox
  end
  s = nil
  begin
    s = Solver.new(box)
  rescue
    puts "User Error, Replace and Continue"
    exit
  end     
  d = s.solve
  if d.nil?
    puts "Unsolvable"
    exit
  end
  system("cls")
  puts d.print
end