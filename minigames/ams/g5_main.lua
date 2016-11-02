--How does this game end?

--If sun turns white then it explodes
--Make growing a velocity
--throw in some planets after an explosion

--Score is total mass of planets

--Start with carl sagan voice altered quote
--we are all star dust
--stars are cool

--animated background stars






--Move force is affected by all planets?  or just those pulling?
--MAybe don't make orbit based on size?  make it fixed?  So you don't have these gigantic orbits

function g5NewImage(filePath)
	return lg.newImage("minigames/ams/"..filePath)
end

function g5NewSource(filePath)
	return la.newSource("minigames/ams/"..filePath)
end
numOfPlanets = 3
im_moon = g5NewImage("moon.png")
im_mars = g5NewImage("mars.png")
im_pluto = g5NewImage("pluto.png")
im_sun = g5NewImage("sun.png")
im_carona = g5NewImage("carona.png")
G = 70
S = 10
realG = false
slowness = 10
real = false
drawForces = false
gravspeed = 400000

planetSpeed = .4
planetFriction = .03
initialBarrage = 30
planetSpawnRate = 140
planetThrowSpeed = 7

traillength = 80
trailresolution = 10
trailduration = 300
trailOpacity = 30

minPlanetSize = .2
maxPlanetSize = 1

sunOrbitSpeed = 1
sunDistances = 175

sunSize = .4
sunPullForce = .3--.6
sunShrinkRate = .008
sunSlowRate = .045

criticalSpeed = 15
explosionForce = 1
respawnTime = 100
appearTime = 180


function g5_load()
	simpleScale.setScreen(800, 450, 16*60, 9*60, {fullscreen=false, vsync=true, msaa=0})
	drawForcess = true
	planets = {}
	suns = {}

	table.insert(suns, {num = 1, key = "q", x=400 - 450*1/4, y = 450*1/4, lr = 1, size = 1, speed = 1, spin = 0, deadtimer = 1, orbitDistance = sunDistances})
	table.insert(suns, {num = 2, key = "z", x=400 - 450*1/4, y = 450*3/4, lr = 1, size = 1, speed = 1, spin = 0, deadtimer = 1, orbitDistance = sunDistances})
	table.insert(suns, {num = 3, key = "p", x=400 + 450*1/4, y = 450*1/4, lr = -1, size = 1, speed = 1, spin = 0, deadtimer = 1, orbitDistance = sunDistances})
	table.insert(suns, {num = 4, key = "m", x=400 + 450*1/4, y = 450*3/4, lr = -1, size = 1, speed = 1, spin = 0, deadtimer = 1, orbitDistance = sunDistances})
	suns[0] = {num = 1, key = "nothing", x=-1000, y = -1000, lr = 1, size = .1, speed = 1, spin = 0, deadtimer = 1, orbitDistance = sunDistances}

	time = 0
end

function insertPlanet(kind, x, y, xv, yv, size)
	local im = im_moon
	local center = {x=15,y=15}
	if size < (maxPlanetSize - minPlanetSize)*.1 then
		im = im_pluto
		center = {x=15,y=15}
	elseif kind == 2 then
		im = im_mars
		center = {x=15,y=15}
	else
		im = im_moon
		center = {x=15,y=15}
	end
	table.insert(planets, {im=im,x=x,y=y,center=center,xv=xv,yv=yv,size=size,trail = {},orbitxv=xv,orbityv=yv})
end

function throwPlanet()
	ang = cu.floRan(0, 2*math.pi)
	randDis = cu.floRan(800,1000) --300
	insertPlanet(math.random(numOfPlanets), 400 + math.cos(ang)*randDis, 225 - math.sin(ang)*randDis, -math.cos(ang)*planetThrowSpeed, math.sin(ang)*planetThrowSpeed, cu.floRan(minPlanetSize,maxPlanetSize))
end

function updatePlanets()
	for i,planet in ipairs(planets) do

		if planet.x < -1000 or planet.x > 1800 or planet.y < -1000 or planet.y > 1450 then
			table.remove(planets, i)
		end

		sundis = -1
		planet.mysun = suns[0]
		for j,sun in ipairs(suns) do
			thisSunDis = cu.dis(planet.x, planet.y, sun.x, sun.y)/sun.size
			if not sun.dead and (sundis == -1 or thisSunDis < sundis) then
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

		planet.orbitxv = (math.cos(orbitang)/math.sqrt(dis))*planet.size*planet.mysun.size*planetSpeed
		planet.orbityv = (math.sin(orbitang)/math.sqrt(dis))*planet.size*planet.mysun.size*planetSpeed

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

function updateSuns()
	for i,sun in ipairs(suns) do
		sun.orbitDistance = sun.orbitDistance+math.sin((time/160)+(math.pi/2)*i)/8--18
		sun.x = 400 + math.cos(sunOrbitSpeed*time/800+(sun.num*math.pi/2)+math.pi/4)*sun.orbitDistance
		sun.y = 225 + math.sin(sunOrbitSpeed*time/800+(sun.num*math.pi/2)+math.pi/4)*sun.orbitDistance
		if sun.speed > criticalSpeed and not sun.dead then
			for i,planet in ipairs(planets) do
				dis = cu.dis(planet.x, planet.y, sun.x, sun.y)/400
				sunang =  math.atan2((sun.x-planet.x),(sun.y-planet.y))-math.pi/2
				planet.xv = planet.xv - ((sun.size*planet.size)/(dis))*math.cos(sunang)*explosionForce
				planet.yv = planet.yv + ((sun.size*planet.size)/(dis))*math.sin(sunang)*explosionForce
			end

			sun.dead = true
			sun.size = 0
		end

		if not sun.dead then
			sun.spin = sun.spin + sun.speed
			if lk.isClick(sun.key) then
				sun.size = sun.size + .1
				sun.speed = sun.speed + 1
				for i,planet in ipairs(planets) do
					if planet.mysun.num ~= sun.num then
						dis = (cu.dis(planet.x, planet.y, sun.x, sun.y)/400)
						sunang =  math.atan2((sun.x-planet.x),(sun.y-planet.y))-math.pi/2
						planet.xv = planet.xv + ((sun.size*planet.size)/(dis))*math.cos(sunang)*sunPullForce
						planet.yv = planet.yv - ((sun.size*planet.size)/(dis))*math.sin(sunang)*sunPullForce

					end
				end
			else
				if sun.size >= 1 then
					sun.size = sun.size - sunShrinkRate
				else
					sun.size = 1
				end


				if sun.speed >= 1 then
					sun.speed = sun.speed - sunSlowRate
				else
					sun.speed = 1
				end
			end
		else
			if sun.deadtimer > appearTime or sun.speed == 1 then
				sun.deadtimer = 1
				sun.speed = 1
			else
				sun.deadtimer = sun.deadtimer + 1
			end

			if sun.size < 1 then
				sun.size = sun.size + 1/(respawnTime+appearTime)
			else
				sun.dead = false
				sun.size = 1
			end
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
			if planet.mysun ~= nil then
				setPlayerColor(planet.mysun.num, ((tra.time)/trailduration)*trailOpacity)
			end
			lg.circle("fill", tra.x, tra.y, trailscale*planet.size*10)
		end

		lg.setColor(255,255,255)
		lg.draw(planet.im, planet.x, planet.y, 0, planet.size, planet.size, planet.center.x, planet.center.y)
	end
end

function drawSuns()
	for i,sun in ipairs(suns) do	
		if sun.dead and sun.speed >= criticalSpeed then
			setPlayerColor(sun.num, 255-sun.deadtimer*math.sqrt(sun.deadtimer))
		else
			lg.setColor(255,255,255,math.min(sun.speed*10+10,255))
		end
		lg.draw(im_carona, sun.x, sun.y, sun.spin/40+math.pi/2, (2*sun.size*sun.size+sun.speed/20)*sun.lr*sun.deadtimer*sun.deadtimer*sunSize, (2*sun.size*sun.size+sun.speed/cu.floRan(9,12))*sun.deadtimer*sun.deadtimer*sunSize, 35, 35)	
		lg.draw(im_carona, sun.x, sun.y, -((sun.spin*1.1)/40+math.pi/4)+sun.spin/100, (2*sun.size*sun.size+sun.speed/20)*sun.lr*sun.deadtimer*sun.deadtimer*.8*sunSize, (2*sun.size*sun.size+sun.speed/cu.floRan(9,12))*sun.deadtimer*sun.deadtimer*.8*sunSize, 35, 35)	
		lg.setColor(255,255,255)
		mycolor = playerColors[sun.num+1]
		newcolor = {
			mycolor[1] + (255-mycolor[1])*(sun.speed/criticalSpeed),
			mycolor[2] + (255-mycolor[2])*(sun.speed/criticalSpeed),
			mycolor[3] + (255-mycolor[3])*(sun.speed/criticalSpeed),
			255
		}
		colorSwap.send({nil, newcolor})
		colorSwap.set()
		lg.draw(im_sun, sun.x, sun.y, 0, 2*sun.size*sun.size*sun.lr*sunSize, 2*sun.size*sun.size*sunSize, 20, 20)
		unsetPlayerColor()

	end
end


function slowWobble(planet)
	if planet.xv > 0 then
		planet.xv = planet.xv - planetFriction
		if planet.xv <= 0 then
			planet.xv = 0
		end
	elseif planet.xv < 0 then
		planet.xv = planet.xv + planetFriction
		if planet.xv >= 0 then
			planet.xv = 0
		end
	end


	if planet.yv > 0 then
		planet.yv = planet.yv - planetFriction
		if planet.yv <= 0 then
			planet.yv = 0
		end
	elseif planet.yv < 0 then
		planet.yv = planet.yv + planetFriction
		if planet.yv >= 0 then
			planet.yv = 0
		end
	end
end

function g5_update()
	updatePlanets()
	updateSuns()
	time = time + 1

	if time%planetSpawnRate == 0 then
		throwPlanet()
	end
	
	if time == 1 then
		for i = 0, initialBarrage do			
			throwPlanet()
		end
	end
end



function g5_draw()
	simpleScale.transform()
	drawPlanets()
	drawSuns()
	simpleScale.letterBox()
end