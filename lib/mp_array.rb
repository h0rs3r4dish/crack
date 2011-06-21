# Monkeypatches for the Array class

class Array
	def rand
		self[Kernel.rand(self.length)]
	end
	def rand!
		self.slice(Kernel.rand(self.length), 1)
	end
end
