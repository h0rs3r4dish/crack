module Crack

class MapTile
	attr_reader :type, :items
	def initialize(type=:wall)
		@seen = false
		@items = Array.new
		@type = type
	end
	def seen?; @seen; end
	def add_item(i); @items << i; end
	def pop_item(i); @items.slice(@items.index_of(i),1); end
end

class Map
	def initialize(w,h)
		@map = Array.new(h) { Array.new(w) }
	end
	def generate!
		@map.each { |row| row.map { MapTile.new } }
	end
end

end
