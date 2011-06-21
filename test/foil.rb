require "lib/foil"

describe "Window" do
	it "should have a blank map when it is created" do
		window = Foil::Window.new(0,0,1,1)
		def window.map; @map; end
		window.map.should == " "
	end
end
