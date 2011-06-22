require "lib/foil"

def sandbox_window(w)
	def w.print(*a); end
	def w.puts(*a); end
	def w.cursor_to(*a); end
	def w.cursor_up(*a); end
	def w.cursor_down(*a); end
	def w.cursor_left(*a); end
	def w.cursor_right(*a); end
end

class Foil::Window
	attr_reader :map
end

describe Foil::Window do
	it "has a blank map when first created", [0,0,1,1] do
		subject.map.first.should == " "
	end
	it "allows placing letters", [0,0,3,1] do
		sandbox_window subject
		subject.char_at(1,0,"b")
		subject.map.first.should == " b "
	end
	it "wraps words automatically", [0,0,3,1] do
		sandbox_window subject
		subject.text_at(0,0,"four")
		subject.map[0].should == "fou"
		subject.map[1].should == "r  "
	end
end
