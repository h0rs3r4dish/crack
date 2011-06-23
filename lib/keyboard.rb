def getch
	STDIN.getc
end

def keyboard_init
	system "stty raw -echo"
end

def keyboard_reset
	system "stty -raw echo"
end
