require "lib/foil"
require "lib/eventlog"
require "lib/keyboard"

begin
Log.open("techdemo")
Log.puts "Initializing keyboard inteface"
keyboard_init

w_main = Foil::Window.new(1,0,80,23) # Rest of the window
w_msgs = Foil::Window.new(0,0,80,1) # One line at the top

w_main.clear
w_msgs.clear

w_msgs.text_at(0,0,"Key:")

coords = [0,0]

while (key = getch) != "q"
	w_msgs.text_at(5,0,key)
	case key
		when "h"
			coords[0] -=1
		when "j"
			coords[1] += 1
		when "k"
			coords[1] -= 1
		when "l"
			coords[0] += 1
	end
	w_main.cursor_to(*coords)
end

ensure
Log.puts "Resetting the keyboard to default"
keyboard_reset
Log.close
end
