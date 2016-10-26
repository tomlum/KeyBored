--Move force is affected by all planets?  or just those pulling?


function g5NewImage(filePath)
	return lg.newImage("minigames/ams/"..filePath)
end

function g5NewSource(filePath)
	return la.newSource("minigames/ams/"..filePath)
end

im_moon = g5NewImage("moon.png")
im_sun = g5NewImage("sun.png")
G = 70
S = 10
realG = false
slowness = 10
traillength = 20
trailresolution = 1
trailduration = 60
real = false
drawForces = false
speed = 2
gravspeed = 400000

function g5_load()
	drawForcess = true
	planets = {}
	suns = {}
	table.insert(suns, {num = 1, key = "q", x=300, y = height*1/4, lr = 1, size = 1})
	table.insert(suns, {num = 2, key = "z", x=300, y = height*3/4, lr = 1, size = 1})
	table.insert(suns, {num = 3, key = "p", x=width-300, y = height*1/4, lr = -1, size = 1})
	table.insert(suns, {num = 4, key = "m", x=width-300, y = height*3/4, lr = -1, size = 1})

	time = 0

	function insertPlanet(kind, x, y, xv, yv, size)
		local im = im_moon
		local center = {x=15,y=15}
		if kind == 1 then
			im = im_moon
			center = {x=15,y=15}
		end
		table.insert(planets, {im=im,x=x,y=y,center=center,xv=xv,yv=yv,size=size,trail = {},orbitxv=xv,orbityv=yv})
	end


	function updatePlanets()
		for i,planet in ipairs(planets) do
			sundis = -1
			planet.mysun = suns[0]
			for j,sun in ipairs(suns) do
				thisSunDis = cu.dis(planet.x, planet.y, sun.x, sun.y)/sun.size
				if sundis == -1 or thisSunDis < sundis then
					sundis = thisSunDis
					planet.mysun = suns[j]
				end
			end

			dis = cu.dis(planet.x, planet.y, planet.mysun.x, planet.mysun.y)

			orbitang = math.atan2(planet.orbitxv+planet.xv,-planet.orbitxv-planet.yv)-math.pi/2
			sunang =  math.atan2((planet.mysun.x-planet.x),(planet.mysun.y-planet.y))-math.pi/2
			difang =  orbitang%(2*math.pi) - sunang%(2*math.pi)

			disone = cu.dis(planet.x + planet.orbitxv*10 + planet.xv, planet.y - planet.orbityv*10 - planet.yv, planet.x + math.cos(sunang+math.pi/2)*10, planet.y - math.sin(sunang+math.pi/2)*10)
			distwo = cu.dis(planet.x + planet.orbitxv*10 + planet.xv, planet.y - planet.orbityv*10 - planet.yv, planet.x + math.cos(sunang-math.pi/2)*10, planet.y - math.sin(sunang-math.pi/2)*10)
			
			if disone < distwo then
				orbitang =  sunang+(math.pi/2)-(planet.mysun.size/gravspeed)
			else
				orbitang =  sunang-(math.pi/2)+(planet.mysun.size/gravspeed)
			end

			planet.orbitxv = (math.cos(orbitang)/math.sqrt(dis))*planet.size*planet.mysun.size*speed
			planet.orbityv = (math.sin(orbitang)/math.sqrt(dis))*planet.size*planet.mysun.size*speed

			--orbitxdir = orbitx/math.abs(orbitx)
			--orbitydir = orbity/math.abs(orbity)

			slowWobble(planet)

			planet.x = planet.x + planet.orbitxv*10 + planet.xv
			planet.y = planet.y - planet.orbityv*10 + planet.yv



			if drawForces then	
				--Draw Wobble Motion				
				lg.setColor(0,255,0)
				lg.line(planet.x, planet.y, planet.x+planet.xv*60, planet.y + planet.yv*60)
				lg.circle("fill", planet.x+planet.xv*60, planet.y + planet.yv*60, 10)

				--Draw Orbit Motion
				lg.setColor(100,100,100)
				lg.line(planet.x, planet.y, planet.x+planet.orbitxv*60, planet.y - planet.orbityv*60)
				lg.circle("fill", planet.x+planet.orbitxv*60, planet.y - planet.orbityv*60, 10)

				--Draw Sun Line
				lg.setColor(255,255,0)
				lg.line(planet.x, planet.y, planet.x+dis*math.cos(sunang), planet.y-dis*math.sin(sunang))
			end




		end
	end

	function drawPlanets()
		for i,planet in ipairs(planets) do
			lg.setColor(255,255,255)

			if time%trailresolution == 0 then
				table.insert(planet.trail, {x = planet.x, y = planet.y, time = trailduration})
			end

			for i,tra in ipairs(planet.trail) do
				tra.time = tra.time - 1
				if tra.time <= 0 then
					table.remove(planet.trail, i)
				end

				local trailscale = planet.size-((trailduration-tra.time)/trailduration)*planet.size
				lg.setColor(255,255,255,((tra.time)/trailduration)*50)
				lg.draw(planet.im, tra.x, tra.y, 0, trailscale, trailscale, planet.center.x, planet.center.y)
			end

			lg.setColor(255,255,255)
			lg.draw(planet.im, planet.x, planet.y, 0, planet.size, planet.size, planet.center.x, planet.center.y)
		end
	end

end


function slowWobble(planet)
	if planet.xv > 0 then
		planet.xv = planet.xv - .05
		if planet.xv <= 0 then
			planet.xv = 0
		end
	elseif planet.xv < 0 then
		planet.xv = planet.xv + .05
		if planet.xv >= 0 then
			planet.xv = 0
		end
	end


	if planet.yv > 0 then
		planet.yv = planet.yv - .05
		if planet.yv <= 0 then
			planet.yv = 0
		end
	elseif planet.yv < 0 then
		planet.yv = planet.yv + .05
		if planet.yv >= 0 then
			planet.yv = 0
		end
	end
end

function g5_update()
	updatePlanets()
	for i,sun in ipairs(suns) do
		if lk.isClick(sun.key) then
			sun.size = sun.size + .1
			for i,planet in ipairs(planets) do
				if planet.mysun.num ~= sun.num then
					dis = cu.dis(planet.x, planet.y, sun.x, sun.y)/400
					sunang =  math.atan2((sun.x-planet.x),(sun.y-planet.y))-math.pi/2
					planet.xv = planet.xv + ((sun.size*planet.size)/(dis*dis))*math.cos(sunang)
					planet.yv = planet.yv - ((sun.size*planet.size)/(dis*dis))*math.sin(sunang)

				end
			end
		else
			if sun.size >= 1 then
				sun.size = sun.size-.005
			else
				sun.size = 1
			end
		end
	end
	time = time + 1
	if time%1 == 0 and time < 20 then
		insertPlanet(1, cu.floRan(width), cu.floRan(height), cu.floRan(-5,5), cu.floRan(-5,5), cu.floRan(.5,1))
		--insertPlanet(1, suns[1].x, suns[1].y, 0, 0, math.random(3))
	end
end



function g5_draw()
	for i,sun in ipairs(suns) do
		lg.draw(im_sun, sun.x, sun.y, 0, sun.size*sun.size*sun.lr, sun.size*sun.size, 20, 20)
	end
	drawPlanets()
end