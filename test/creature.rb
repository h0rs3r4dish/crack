require "lib/creature"

describe Crack::Creature do
	it "populates attributes from a template", :goblin do
		subject.type.should == :goblin
		subject.name.should == "Goblin"
	end
end
