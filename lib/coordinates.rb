CoordinatePair = Struct.new(:x, :y) do
	def to_a
		[x, y]
	end
end
