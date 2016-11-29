--"Sun it's time to go home, and bring your toys with you!"

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


function g5_load()
	simpleScale.updateScreen(800, 450)
	drawForcess = true
	planets = {}
	suns = {}
	stars = {}

	gameLength = 2000

	numOfPlanets = 6
	planetCap = 100
	im_moon = g5NewImage("moon.png")
	im_mars = g5NewImage("mars.png")
	im_pluto = g5NewImage("pluto.png")
	im_sun = g5NewImage("sun.png")
	im_carona = g5NewImage("carona.png")
	im_saturn = g5NewImage("saturn.png")
	im_neptune = g5NewImage("neptune.png")
	im_earth = g5NewImage("earth.png")
	im_star = g5NewImage("star.png")
	im_galaxy = g5NewImage("galaxy.png")
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
	maxTilt = math.pi/8

	traillength = 80
	trailresolution = 10
	trailduration = 500
	trailOpacity = 30

	minPlanetSize = .7
	maxPlanetSize = 1

	sunOrbitSpeed = .07
	sunDistances = 175

	sunSize = .7
	sunPullForce = .15--.6
	sunShrinkRate = .008
	sunSlowRate = .045

	criticalSpeed = 15
	explosionForce = 1
	respawnTime = 100
	appearTime = 180

	numberOfStars = 300
	zoomOutTime = 150
	startMovingTime = zoomOutTime-100
	fadeTime = 140


	table.insert(suns, {num = 1, key = "q", x=400 - 450*1/4, y = 450*1/4, lr = 1, size = 1, speed = 1, spin = 0, deadtimer = 1, orbitDistance = sunDistances})
	table.insert(suns, {num = 2, key = "z", x=400 - 450*1/4, y = 450*3/4, lr = 1, size = 1, speed = 1, spin = 0, deadtimer = 1, orbitDistance = sunDistances})
	table.insert(suns, {num = 3, key = "p", x=400 + 450*1/4, y = 450*1/4, lr = -1, size = 1, speed = 1, spin = 0, deadtimer = 1, orbitDistance = sunDistances})
	table.insert(suns, {num = 4, key = "m", x=400 + 450*1/4, y = 450*3/4, lr = -1, size = 1, speed = 1, spin = 0, deadtimer = 1, orbitDistance = sunDistances})
	suns[0] = {num = 1, key = "nothing", x=-1000, y = -1000, lr = 1, size = .1, speed = 1, spin = 0, deadtimer = 1, orbitDistance = sunDistances}

	time = 0
	time2 = 0
	zoom = 1

	for i = 0, numberOfStars do
		table.insert(stars, {x = cu.floRan(-1500,800+1500), y = cu.floRan(-1200+450,1200), size = cu.floRan(.5,1.5), flicker = cu.floRan(10), rot = cu.floRan(-math.pi/4, math.pi/4)})
	end
end


function drawStars()
	for i,v in ipairs(stars) do 
		v.flicker = v.flicker + .01
		lg.draw(im_star, v.x, v.y, rot, v.size*math.sin(v.flicker), v.size*math.sin(v.flicker), 12.5, 12.5)
	end
end

function insertPlanet(kind, x, y, xv, yv, size)
	local im = im_moon
	local center = {x=15,y=15}
	if size < minPlanetSize+(maxPlanetSize - minPlanetSize)*.1 then
		im = im_pluto
		center = {x=15,y=15}
	elseif cu.floRan(0,1)<.01 then
		im = im_earth
		center = {x=15,y=15}
	elseif kind == 2 then
		im = im_mars
		center = {x=15,y=15}
	elseif kind == 3 then
		im = im_saturn
		center = {x=25,y=15}
	elseif kind == 4 then
		im = im_neptune
		center = {x=15,y=15}
	else
		im = im_moon
		center = {x=15,y=15}
	end
	if #planets < planetCap then
		table.insert(planets, {im=im,x=x,y=y,center=center,xv=xv,yv=yv,size=size,trail = {},orbitxv=xv,orbityv=yv,tilt = cu.floRan(-maxTilt, maxTilt)})
	end
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
		planet.mySun = suns[0]
		for j,sun in ipairs(suns) do
			thisSunDis = cu.dis(planet.x, planet.y, sun.x, sun.y)/sun.size
			if not sun.dead and (sundis == -1 or thisSunDis < sundis) then
				sundis = thisSunDis
				planet.mySun = suns[j]
			end
		end

		dis = cu.dis(planet.x, planet.y, planet.mySun.x, planet.mySun.y)

		orbitang = math.atan2(planet.orbitxv+planet.xv,-planet.orbitxv-planet.yv)-math.pi/2
		sunang = math.atan2((planet.mySun.x-planet.x),(planet.mySun.y-planet.y))-math.pi/2
		difang = orbitang%(2*math.pi) - sunang%(2*math.pi)

		disone = cu.dis(planet.x + planet.orbitxv*10 + planet.xv, planet.y - planet.orbityv*10 - planet.yv, planet.x + math.cos(sunang+math.pi/2)*10, planet.y - math.sin(sunang+math.pi/2)*10)
		distwo = cu.dis(planet.x + planet.orbitxv*10 + planet.xv, planet.y - planet.orbityv*10 - planet.yv, planet.x + math.cos(sunang-math.pi/2)*10, planet.y - math.sin(sunang-math.pi/2)*10)

		if disone < distwo then
			orbitang =  sunang+(math.pi/2)-(planet.mySun.size/gravspeed)
		else
			orbitang =  sunang-(math.pi/2)+(planet.mySun.size/gravspeed)
		end

		planet.orbitxv = (math.cos(orbitang)/math.sqrt(dis))*planet.size*planet.mySun.size*planetSpeed
		planet.orbityv = (math.sin(orbitang)/math.sqrt(dis))*planet.size*planet.mySun.size*planetSpeed

		--orbitxdir = orbitx/math.abs(orbitx)
		--orbitydir = orbity/math.abs(orbity)

		slow(planet)

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
			if lk.isClick(sun.key) then
				sun.size = sun.size + .1
				sun.speed = sun.speed + 1
				for i,planet in ipairs(planets) do
					if planet.mySun.num ~= sun.num then
						dis = (cu.dis(planet.x, planet.y, sun.x, sun.y)/400)
						sunang =  math.atan2((sun.x-planet.x),(sun.y-planet.y))-math.pi/2
						planet.xv = planet.xv + ((sun.size*planet.size)/(dis*dis))*math.cos(sunang)*sunPullForce
						planet.yv = planet.yv - ((sun.size*planet.size)/(dis*dis))*math.sin(sunang)*sunPullForce

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

		--if time%math.max(3, math.floor(trailresolution-(math.sqrt((planet.xv+planet.orbitxv)^2 + (planet.yv+planet.orbityv)^2))*20)) == 0 then
		--	table.insert(planet.trail, {x = planet.x, y = planet.y, time = (trailduration-(math.sqrt((planet.xv+planet.orbitxv)^2 + (planet.yv+planet.orbityv)^2)*20))})
		--end

		if time%trailresolution == 0 then
			table.insert(planet.trail, {x = planet.x, y = planet.y, time = (trailduration-(math.sqrt((planet.xv+planet.orbitxv)^2 + (planet.yv+planet.orbityv)^2)*20)), mySun = planet.mySun or suns[0]})
		end

		for i,tra in ipairs(planet.trail) do
			tra.time = tra.time - 1
			if tra.time <= 0 then
				table.remove(planet.trail, i)
			end

			local trailscale = planet.size-((trailduration-tra.time)/trailduration)*planet.size
			if planet.mySun ~= nil then
				setPlayerColor(tra.mySun.num, ((tra.time)/trailduration)*trailOpacity)
			end
			lg.circle("fill", tra.x, tra.y, trailscale*planet.size*10)
		end

		lg.setColor(255,255,255)
		lg.draw(planet.im, planet.x, planet.y, planet.tilt, planet.size, planet.size, planet.center.x, planet.center.y)
	end
end

function drawSuns()
	for i,sun in ipairs(suns) do	
		if not sun.dead then
			sun.spin = sun.spin + sun.speed
		end
		if sun.dead and sun.speed >= criticalSpeed then
			setPlayerColor(sun.num, 255-sun.deadtimer*math.sqrt(sun.deadtimer))
		else
			lg.setColor(255,255,255,math.min(sun.speed*10+10,255))
		end
		lg.draw(im_carona, sun.x, sun.y, sun.spin/40+math.pi/2, (2*sun.size*sun.size+sun.speed/20)*sun.lr*sun.deadtimer*sun.deadtimer*sunSize, (2*sun.size*sun.size+sun.speed/cu.floRan(9,12))*sun.deadtimer*sun.deadtimer*sunSize, 35, 35)	
		lg.draw(im_carona, sun.x, sun.y, -((sun.spin*1.1)/40+math.pi/4)+sun.spin/100, (2*sun.size*sun.size+sun.speed/20)*sun.lr*sun.deadtimer*sun.deadtimer*.8*sunSize, (2*sun.size*sun.size+sun.speed/cu.floRan(9,12))*sun.deadtimer*sun.deadtimer*.8*sunSize, 35, 35)	
		lg.setColor(255,255,255)
		mycolor = playerColors[sun.num]
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


function slow(planet)
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

function spawnPlanets()
	if time == 1 then
		for i = 0, initialBarrage do			
			throwPlanet()
		end
	elseif time%planetSpawnRate == 0 then
		throwPlanet()
	end
end

function g5_update()
	if time < gameLength then
		updatePlanets()
		updateSuns()
		spawnPlanets()
		time = time + 1
		if time >= gameLength then
			for i,planet in ipairs(planets) do
				planet.finalAng = math.atan2(planet.x - planet.mySun.x, -(planet.y - planet.mySun.y))-math.pi/2
				planet.finalDis = cu.dis(planet.x, planet.y, planet.mySun.x, planet.mySun.y)
			end
		end
	else
		time2 = time2 + 1
		for i,sun in ipairs(suns) do

			sun.size = sun.size + .0001
			if sun.x < 400 then
				sun.lr = -1
			else
				sun.lr = 1
			end

			sun.x = 400 + math.cos(sunOrbitSpeed*time/800+(sun.num*math.pi/2)+math.pi/4)*(sun.orbitDistance+math.max(0, (time2 - zoomOutTime + startMovingTime)))
			sun.y = 225 + math.sin(sunOrbitSpeed*time/800+(sun.num*math.pi/2)+math.pi/4)*(sun.orbitDistance+math.max(0, (time2 - zoomOutTime + startMovingTime)))
			
		end

		for i,planet in ipairs(planets) do
			planet.x = planet.mySun.x + math.cos(planet.finalAng)*planet.finalDis
			planet.y = planet.mySun.y + math.sin(planet.finalAng)*planet.finalDis
		end

		if time2 < zoomOutTime then 
			zoom = zoom*.99
		end
	end

	if time2 > zoomOutTime + startMovingTime + fadeTime then
		fadeV = -7
	end

	if fade == 0 then
		sunScores = {0, 0, 0, 0}
		for i,planet in ipairs(planets) do
			sunScores[planet.mySun.num] = sunScores[planet.mySun.num]+planet.size
		end
		winningScore = sunScores[1]
			winner = 1
		for i = 1, 4 do
			winner = i
			if sunScores[i] > winningScore then
				winningScore = sunScores[i]
				winner = i
			end
		end

		MODE = "RESULTS"
	end
end

function drawGalaxies()
	for i,sun in ipairs(suns) do
		local x = 400 + math.cos(sunOrbitSpeed*time/800+(sun.num*math.pi/2)+math.pi/4)*1600
		local y = 225 + math.sin(sunOrbitSpeed*time/800+(sun.num*math.pi/2)+math.pi/4)*1600

		lg.draw(im_galaxy,x,y,time2/100,20,20,25,25)
		sun.orbitDistance = sun.orbitDistance+math.sin((time/160)+(math.pi/2)*i)/8--18
	end
end


function g5_draw()
	lg.push()
	lg.translate(-(((zoom*800)-800)/2),-(((zoom*450)-450)/2))
	lg.scale(zoom, zoom)
	drawStars()
	drawPlanets()
	drawSuns()
	drawGalaxies()
	lg.pop()
end