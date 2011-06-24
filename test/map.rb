require "lib/map"

describe Crack::MapTile do
	it "defaults to a blank, unseen wall" do
		subject.seen?.should == false
		subject.type.should == :wall
		subject.items.length.should == 0
	end
	it "allows the setting of its type through its constructor", :floor do
		subject.type.should == :floor
	end
	it "can accept items being dropped and taken off of it" do
		items = [
			mock({ :name => "Sword of Walrus Slaying" }),
			mock({ :name => "Helm of Grue Detection" })
		]

		items.each { |item| subject.add_item item }
		subject.items.length.should == 2

		item = subject.pop_item items.first
		item.should == items.first
		subject.items.length.should == 1
		subject.items.should == [ items.last ]
	end
end

describe Crack::Floor do
	module Log; class << self; def puts *a; end; def open *a; end; end; end
end
