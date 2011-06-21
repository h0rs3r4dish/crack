def getch
	STDIN.getc
end

def keyboard_setup
	system "stty raw -echo"
end

def keyboard_teardown
	system "stty -raw echo"
end
