function g6NewImage(filePath)
	return lg.newImage("minigames/pm/"..filePath)
end

function g6NewSource(filePath)
	return la.newSource("minigames/pm/"..filePath)
end


function g6_load()
	simpleScale.updateScreen(800, 450)
	
end


function g6_update()

end


function g6_draw()
	lg.draw
end