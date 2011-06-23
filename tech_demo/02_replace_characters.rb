require "lib/foil"
require "lib/eventlog"
require "lib/keyboard"

begin
Log.open("techdemo")
Log.puts "Initializing keyboard inteface"
keyboard_init

Log.puts "Creating main window"
w_main = Foil::Window.new(1,0,80,23) # Rest of the window
Log.puts "Creating message window"
w_msgs = Foil::Window.new(0,0,80,1) # One line at the top

Log.puts "Clearing all windows"
w_main.clear
w_msgs.clear

Log.puts "Putting down main window background"
w_main.text_at(0,0,"map!" * 20 * 23)

Log.puts "Setting up the keypress notification"
w_msgs.text_at(0,0,"Key:")

Log.puts "Initializing coordinates to 0,0"
coords = [0,0]
Foil.cursor_to coords.first, (coords.last + 1)
print "@"

Log.puts "Starting loop"
while (key = getch) != "q"
	w_msgs.text_at(5,0,key)
	Log.puts "Redrawing #{w_main.get_char_at(*coords)} at #{coords}"
	w_main.redraw(*coords,1,1) # Wipe over the @
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
	Log.puts "Drawing @ at #{coords}"
	Foil.cursor_to coords.first, (coords.last + 1)
	print "@"
end

ensure
Log.puts "Resetting the keyboard to default"
keyboard_reset
Log.close
end
