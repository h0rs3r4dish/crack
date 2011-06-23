module Foil

class Window
	attr_reader :window_id, :dimensions, :hidden

	def initialize(x=0,y=0,w=80,h=24)
		@dimensions = { :x => x, :y => y, :w => w, :h => h }
		@map = Array.new(h) { " " * w }
		@window_id = Foil.register_window self
		@hidden = false
	end

	def hide
		Foil.hide_window self
		@hidden = true
	end
	def show
		redraw 0, 0, @dimensions[:w], @dimensions[:h]
		@hidden = false
	end

	def get_char_at(x,y)
		@map[y][x]
	end
	def get_char_range(x,y,w,h)
		(0..h).map { |hh|
			@map[hh][x..(x+w)]
		}
	end

	def redraw(x,y,w,h)
		h.times { |hh|
			yy = y + hh
			cursor_to x, yy
			print @map[yy][x..(x+w-1)]
		}
	end
		
	def clear
		@map = Array.new(@dimensions[:h]) { |y|
			cursor_to 0, y
			print (spaces = " " * @dimensions[:w])
			spaces
		}
	end
	def text_at(x, y, text)
		perline = @dimensions[:w] - x
		text.split("\n").each { |line|
			if line.length > perline then
				loc = 0
				while loc < line.length
					cursor_to(x, y)
					endloc = loc + perline
					segment = line[loc, endloc]

					print segment
					@map[y][x..(x + segment.length - 1)] = segment

					loc += perline
					y += 1
					return if y > @dimensions[:h]
				end
			else
				cursor_to x, y
				print line
				@map[y][x..(x + line.length)] = line
				y += 1
			end
			return if y > @dimensions[:h]
		}
	end
	def char_at(x, y, c)
		cursor_to(x, y)
		print c
		@map[y][x] = c
	end

	def cursor_up(n=1); print "\033[#{n}A"; end
	def cursor_down(n=1); print "\033[#{n}B"; end
	def cursor_right(n=1); print "\033[#{n}C"; end
	def cursor_left(n=1); print "\033[#{n}D"; end
	def cursor_to(l=1,c=1)
		l += @dimensions[:y]+1; c += @dimensions[:x]+1
		print "\033[#{c};#{l}H"
	end
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
		@window_list.reverse.each { |ww|
			ww.show unless ww == w or w.hidden
		}
	end

	def cursor_to(x, y)
		print "\033[#{y+1};#{x+1}H"
	end

end

end
