function g5NewImage(filePath)
	return lg.newImage("minigames/ams/"..filePath)
end

function g5NewSource(filePath)
	return la.newSource("minigames/ams/"..filePath)
end

moon = g5NewImage("moon.png")
sun = g5NewImage("sun.png")

function g5_load()
	planets = {}
	suns = {}
	table.insert(suns, {x=100, y = height/2, lr = 1})
	table.insert(suns, {x=width-100, y = height/2, lr = -1})

	time = 0

	function insertPlanet(kind, x, y, xv, yv, size)
		local im = moon
		local center = {x=15,y=15}
		if kind == 1 then
			im = moon
			center = {x=15,y=15}
		end
		table.insert(planets, {im=im,x=x,y=y,center=center,xv=xv,yv=yv,size=size})
	end

	function updatePlanets()
		for i,planet in ipairs(planets) do
			planet.x = planet.x + planet.v
		end
	end

	function drawPlanets()
		for i,planet in ipairs(planets) do
			lg.draw(planet.im, planet.x, planet.y, 0, planet.size, planet.size, planet.center.x, planet.center.y)
		end
	end
end



function g5_update()
	time = time + 1
	if time%200 == 1 then
		insertPlanet(1, math.random(width), math.random(height), 0, 0, math.random(10))
	end
	--updatePlanets()
end



function g5_draw()
	for i,sun in ipairs(suns) do
		lg.draw()
	end
	drawPlanets()
end