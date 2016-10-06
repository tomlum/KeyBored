function repplay(x)
	if x:isStopped() then
		x:play()
	else
		x:rewind()
		x:play()
	end
end