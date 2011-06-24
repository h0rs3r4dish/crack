require "lib/foil"
require "lib/map"
require "lib/keyboard"
require "lib/symbols"

begin
keyboard_init

w_main = Foil::Window.new(0,2,80,22)
w_msgs = Foil::Window.new(0,0,80,2)

w_main.clear
w_msgs.clear
w_msgs.text_at(0,0, "Tech Demo 3: Map Generator")
w_msgs.text_at(0,1, "Ready to generate.")
(keyboard_reset; exit) if getch == "q"
w_msgs.text_at(0,1, "Generating floor...")

f = Crack::Floor.new(75,22)
f.generate!

w_msgs.clear
w_msgs.text_at(0,1, "Finished generating")
f.map.each_with_index { |row, y|
	w_main.cursor_to 0, y
	row.each { |tile|
		print Crack::SYMBOLS[tile.type]
	}
}

ensure
keyboard_reset
end
