require "lib/mp_array.rb"

module Crack

class Creature
	attr_reader :type, :name
	def initialize(type, location=[0,0])
		@type = type
		@name = Crack::CREATURES[type][:name]
		@attributes = Crack::CREATURES[type][:attributes]
		@heath = @attributes[:max_health]
		@weapon = Crack::CREATURES[type][:weapon].rand
	end
end

CREATURES = {
	:goblin => {
		:name => "Goblin",
		:attributes => {
			:max_health => 8,
			:str => 7,
			:dex => 7,
			:int => 6
		},
		:weapon => []
	}
}

end
