module Foil

class Window
	attr_reader :window_id, :dimensions

	def initialize(x,y,w=80,h=24)
		@dimensions = { :x => x, :y => y, :w => w, :h => h }
		@map = " " * w * h
		@window_id = Foil.register_window self
	end

	def hide
		Foil.hide_window self
	end
	def show
		redraw @dimensions.values
	end

	def get_char_at(x,y)
		@map[x * y]
	end
	def get_char_range(x,y,w,h)
		(0..h).map { |hh|
			@map[x*hh, (x+w)*hh]
		}
	end

	def redraw(x,y,w,h)
		h.times { |hh|
			yy = y + hh
			text_at(x,y+hh, @map[x * yy, (x + w) * yy])
		}
	end
		

	def clear
		cursor_to(0, 0)
		@map = ""
		@dimensions[:h].times {
			spaces = " " * @dimensions[:w]
			puts spaces
			@map += spaces
		}
	end
	def text_at(x, y, text)
		cx = x; cy = y;
		perline = @dimensins[:w] - x
		text.split("\n").each { |line|
			if line.length > perline then
				loc = 0
				while loc < line.length
					cursor_to(cx, cy)
					start = cx * cy
					segment = line[loc, loc+perline]

					puts segment
					@map[start, start+perline] = segment

					loc += perline
					cy += 1
					return if cy > @dimensions[:h]
				end
			else
				cursor_to(cx, cy)
				start = cx * cy

				puts line
				@map[start, start + line.length] = line

				cy += 1
			end
			return if cy > @dimensions[:h]
		}
	end

	def cursor_up(n=1); print "\033[#{n}A"; end
	def cursor_down(n=1); print "\033[#{n}B"; end
	def cursor_right(n=1); print "\033[#{n}C"; end
	def cursor_left(n=1); print "\033[#{n}D"; end
	def cursor_to(l=0,c=0); print "\033[#{l};#{c}H"; end
end

class << self
	def setup
		@window_list = Array.new
		@window_id = -1
	end
	def register_window(w)
		setup if @window_list.nil? 
		@window_list.unshift w
		@window_id += 1
		return @window_id
	end
	def hide_window(w)
		# FIXME: Right now, it redraws everything. Should just find the
		# specific areas to redraw. later. Much later.
		windows.reverse.each { |ww|
			ww.show unless ww == w
		}
	end
end

end
