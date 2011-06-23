module Log
class << self
	def puts(*a)
		@logfile.puts *a
	end
	def open(name, mode="a")
		@logfile = File.new(name + ".log", mode)
	end
	def close
		@logfile.close
	end
end
end
