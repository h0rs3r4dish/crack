module Crack

class Item
	def initialize(attr, prop={})
		if attr.class == Symbol then
			template = Crack::ITEMS[attr]
			@attributes = template[:attributes]
			@properties = template[:properties]
		else
			@attributes = attr
			@properties = prop
		end
	end
	def set_property(prop, value)
		@properties[prop] = value
	end
	def set_attribute(attr)
		@attributes << attr unless @attributes.inclue? attr
	end
	def method_missing(m,*args)
		request = m.to_s
		if request =~ /^is_([^ ])\?$/ then
			return @attributes.include? $1.intern
		elsif @properties.key? m then
			return @properties[m]
		else
			raise MethodMissingError
		end
	end
end

ITEMS = {
	:blank => {
		:attributes => [],
		:properties => {}
	},

# Weapons
	:dagger => {
		:attributes => [ :weapon, :metal ],
		:properties => {
			:name => "Dagger",
			:damage => :d6
		}
	}


# Potions
	:potion_healing => {
		:attributes => [ :potion, :breakable ],
		:properties => {
			:name => "Potion of healing",
			:effect => :heal,
		}
	}
}

end
