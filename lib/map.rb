require "lib/eventlog"

module Crack

class MapTile
	attr_reader :type, :items
	def initialize(type=:wall)
		@seen = false
		@items = Array.new
		@type = type
	end
	def set_type(t); @type = t; end
	def seen?; @seen; end
	def add_item(i); @items << i; end
	def pop_item(i); @items.delete_at(@items.index(i)); return i; end
end

class Floor
	FLOOR_WIDTH  = 80
	FLOOR_HEIGHT = 23

	GENERATE_ROOM_PROBABILITY = 0.75

	def initialize(w,h)
		@map = Array.new(h) { Array.new(w) }
	end


	# Map generator stuff
	def generate!
		Log.open "mapgen"
		Log.puts "Initializing blank map"
		@map.each { |row| row.map { MapTile.new } } # Reset the map
		loc_stair_up = rand 6; loc_stair_down = rand 6; # What sector they're in
		while loc_stair_up == loc_stair_down; loc_stair_down = rand 6; end
		Log.puts "Stairs -- Up: #{loc_stairs_up} -- Down: #{loc_stairs_down}"
		offset_x_factor = FLOOR_WIDTH / 3; offset_y_factor = FLOOR_WIDTH / 2;
		cur_sector = 0
		Log.puts "Starting sector generation"
		3.times { |sector_x|
			2.times { |sector_y|
				Log.puts "Current sector: #{cur_sector}"
				offset_x = offset_x_factor * sector_x
				offset_y = offset_y_factor * sector_y
				Log.puts "Tile offset: #{offset_x}x#{offset_y}"
				if rand < GENERATE_ROOM_PROBABILITY then
					generate_room(offset_x, offset_y)
				else
					generate_hallway(offset_x, offset_y)
				end
				generate_stair(:up, cur_sector) if cur_sector == loc_stair_up
				genreate_stair(:down,cur_sector) if cur_sector == loc_stair_down
					
				cur_sector += 1
			}
		}
		generate_sector_connections(rand 6) # Start at a random sector
	end

	def generate_room(offset_x, offset_y)
		Log.puts "Generating a room"
	end
	def generate_hallway(offset_x, offset_y)
		Log.puts "Generating a hallway"
	end
	def generate_stair(dir, sector)
		Log.puts "Creating stairs #{dir} in sector #{sector}"
	end
	def generate_sector_connections(start_sector)
		Log.puts "Connecting all sectors, starting at #{start_sector}"
	end
end

end
