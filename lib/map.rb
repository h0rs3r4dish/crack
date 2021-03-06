require "lib/eventlog"

module Crack

class MapTile
	attr_reader :items
	attr_accessor :type
	def initialize(type=:blank)
		@seen = false
		@items = Array.new
		@creatures = Array.new
		@type = type
	end
	def seen?; @seen; end
	def add_item(i); @items << i; end
	def pop_item(i); @items.delete_at @items.index(i); return i; end
	def add_creature(c); @creatures << c; end
	def pop_creature(c); @creatures.delete_at @creatures.index(c); return c; end
end

class Floor
	attr_reader :map

	GENERATE_ROOM_PROBABILITY = 0.75

	def initialize(w,h)
		@map = Array.new(h) { Array.new(w) }
		Floor.const_set "FLOOR_WIDTH", w
		Floor.const_set "FLOOR_HEIGHT", h
		Floor.const_set "SECTOR_WIDTH", (w / 3)
		Floor.const_set "SECTOR_HEIGHT", (h / 2)
		@stairs = { :up => nil, :down => nil }
	end


	# Map generator stuff
	def generate!
		begin
		Log.open "mapgen"
		Log.puts "Initializing blank map"
		@map = @map.map { |row| row.map { MapTile.new } } # Reset the map
		loc_stair_up = rand 6; loc_stair_down = rand 6; # What sector they're in
		while loc_stair_up == loc_stair_down; loc_stair_down = rand 6; end
		Log.puts "Stairs -- Up: #{loc_stair_up} -- Down: #{loc_stair_down}"
		cur_sector = 0
		Log.puts "Starting sector generation"
		3.times { |sector_x|
			2.times { |sector_y|
				Log.puts "Current sector: #{cur_sector}"
				offset_x = SECTOR_WIDTH * sector_x
				offset_y = SECTOR_HEIGHT * sector_y
				Log.puts "Tile offset: #{offset_x}x#{offset_y}"
				stairway = if cur_sector == loc_stair_up then
					:up
				elsif cur_sector == loc_stair_down
					:down
				else
					:none
				end
				if rand < GENERATE_ROOM_PROBABILITY then
					generate_room(offset_x, offset_y, stairway)
				else
					generate_hallway(offset_x, offset_y, stairway)
				end
				cur_sector += 1
			}
		}
		generate_sector_connections(rand 6) # Start at a random sector

		ensure
			Log.close
		end
	end

	def generate_room(offset_x, offset_y, stair)
		Log.puts "Generating a room"

		max_width = SECTOR_WIDTH - 2
		max_height = SECTOR_HEIGHT - 2
		min_width = 3
		min_height = 3
		r_width = rand(max_width - min_width) + min_width
		r_height = rand(max_height - min_height) + min_height
		Log.puts "Room is #{r_width}x#{r_height}"

		startx = offset_x + ((SECTOR_WIDTH - r_width) / 2)
		starty = offset_y + ((SECTOR_HEIGHT - r_height) / 2)

		Log.puts "Creating the floor"
		r_height.times { |current_y|
			y = current_y + starty
			r_width.times { |current_x|
				x = current_x + startx
				@map[y][x].type = :floor
			}
		}

		Log.puts "Creating side walls"
		(r_height).times { |current_y|
			y = current_y + starty
			@map[y][startx - 1].type = :wall
			@map[y][startx + r_width].type = :wall
		}
		Log.puts "Creating top and bottom walls"
		(r_width+2).times { |current_x|
			x = current_x + startx - 1
			@map[starty - 1][x].type = :wall
			@map[starty + r_height][x].type = :wall
		}

		if stair != :none then
			generate_stair(stair, rand(r_width)+startx, rand(r_height)+starty)
		end

		Log.puts "Done with this room"
	end
	def generate_hallway(offset_x, offset_y, stair)
		Log.puts "Generating a hallway"
		x = offset_x + (SECTOR_WIDTH / 2) + 1
		y = offset_y + (SECTOR_HEIGHT / 2) + 1
		Log.puts "Found center of sector at #{x},#{y}"
		Log.puts "Creating floor"
		@map[y][x].type = :floor
		Log.puts "Creating walls"
		[y-1, y+1].each { |wall_y|
			[x-1, x+1].each { |wall_x|
				@map[wall_y][wall_x].type = :wall
				@map[y][wall_x].type = :wall
			}
			@map[wall_y][x].type = :wall
		}
		generate_stair(stair, x, y) if stair != :none
		Log.puts "Done with this hallway"
	end
	def generate_stair(dir, x, y)
		Log.puts "Stairs #{dir} are at #{x},#{y}"
		@stairs[dir] = [x, y]
		@map[y][x].type = "stair_#{dir}".intern
	end
	def generate_sector_connections(start_sector)
		Log.puts "Connecting all sectors, starting at #{start_sector}"
		# Assign vertical hallways randomly, ensuring there's at least one
		vert_halls = Array.new(3); vert_halls[rand(3)] = true;
		vert_halls = vert_halls.map { |v| (v.nil?) ? (rand(2) == 1) : v }
		Log.puts "Vertical hallways: #{vert_halls.join ', '}"
		Log.puts "Creating #{(vert_halls - [false]).length} vertical hallways"
		vert_halls.each_with_index { |hall, start|
			generate_hallway_vertical(start, start+3) if hall
		}
		# Assign horizontal halls; if there's a vert, only one, otherwise both
		horiz_halls = Array.new(2)
		2.times { |id|
			if vert_halls[id..(id+1)] != [true, true] then
				horiz_halls[id] = :both
			else
				horiz_halls[id] = [:top, :bottom, :both][rand 3]
			end
		}
		horiz_halls.each_with_index { |halloc, sector|
			if halloc == :both or halloc == :top then
				Log.puts "Creating top hallway from #{sector} to #{sector+1}"
				generate_hallway_horizontal(sector, sector+1)
			end
			if halloc == :both or halloc == :bottom then
				Log.puts "Creating bottom hall from #{sector+3} to #{sector+4}"
				generate_hallway_horizontal(sector+3, sector+4)
			end
		}
	end
	def generate_hallway_vertical(s_start, s_end)
		Log.puts "Creating hallway from sectors #{s_start} to #{s_end}"
		x = SECTOR_WIDTH / 2
		x += (SECTOR_WIDTH * (s_start % 3)) + 1
		y_start = SECTOR_HEIGHT / 2 + 1
		y_end = 0
		while @map[y_start][x].type != :wall
			y_start += 1
		end
		Log.puts "Fount top wall at #{y_start}"
		y_end = y_start + 1
		while @map[y_end][x].type != :wall
			y_end += 1
		end
		Log.puts "Found bottom wall at #{y_end}"
		(y_start..y_end).each { |y|
			@map[y][x].type = :floor
			@map[y][x-1].type = :wall
			@map[y][x+1].type = :wall
		}
	end
	def generate_hallway_horizontal(s_start, s_end)
		Log.puts "Creating hallway from sectors #{s_start} to #{s_end}"
		y = SECTOR_HEIGHT / 2 + 1
		y += SECTOR_HEIGHT if s_start > 2
		x_start = SECTOR_WIDTH / 2
		x_start += (SECTOR_WIDTH * (s_start % 3)) + 1
		Log.puts "Starting wall search at #{x_start},#{y}"
		x_end = 0
		while @map[y][x_start].type != :wall
			Log.puts "#{x_start},#{y} = #{@map[y][x_start].type}"
			x_start += 1
		end
		Log.puts "Found left wall at #{x_start}"
		x_end = x_start + 1
		while @map[y][x_end].type != :wall
			x_end += 1
		end
		Log.puts "Found right wall at #{x_end}"
		(x_start..x_end).each { |x|
			@map[y-1][x].type = :wall
			@map[y+1][x].type = :wall
			@map[y][x].type = :floor
		}
	end

end

end
