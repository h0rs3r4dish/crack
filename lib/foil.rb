module Foil

class << self
	def cursor_up(n=1); print "\033[#{n}A"; end
	def cursor_down(n=1); print "\033[#{n}B"; end
	def cursor_right(n=1); print "\033[#{n}C"; end
	def cursor_left(n=1); print "\033[#{n}D"; end
	def cursor_to(l=0,c=0); print "\033[#{l};#{c}H"; end
end

class Window
	def new(x,y,w=80,h=24)
		@dimensions = { :x => x, :y => y, :w => w, :h => h }
	end

	def clear
		cursor_to(0, 0)
		@dimensions[:h].times {
			puts " " * @dimensions[:w]
		}
	end

	def text_at(text, x, y)
		cx = x; cy = y;
		perline = @dimensins[:w] - x
		text.split("\n").each { |line|
			if line.length > perline then
				loc = 0
				while loc < line.length
					cursor_to(cx, cy)
					puts line[loc, loc+perline]
					loc += perline
					cy += 1
					return if cy > @dimensions[:h]
				end
			else
				cursor_to(cx, cy)
				puts line
				cy += 1
			end
			return if cy > @dimensions[:h]
		}
	end

	def cursor_to(x, y)
		cx = x + @dimensions[:x]; cy = y + @dimensions[:y]
		raise "Coordinate out of bound" if cx > @dimensions[:w] or cy > @dimensions[:h]
		Foil.cursor_to(cx, cy)
	end

end

end
