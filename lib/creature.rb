require "lib/mp_array.rb"

module Crack

class Creature
	def initialize(type, location=[0,0])
		@name = CREATURES[type][:name]
		@attributes = CREATURES[type][:attr]
		@heath = @attributes[:max_health]
		@weapon = CREATURES[type][:weapon].rand
	end
end

end
