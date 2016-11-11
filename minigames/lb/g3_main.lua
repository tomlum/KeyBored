--IMplement Strikes
--Balance characters so they're in the screen

--Strikes as mistakes you can gloss over
--Strikes doesn't work... jarring to find your place again
--Mark the current record with gold ghost weight
--Fix Saves







--Scream on victory, random victory noise
--explosion sound effect
--Applause, flexing pose 


--Plackard with the names
--Animate bars as moving along with character blaaaaa
--Roundscrore written on board in back?
--Tally for how many tries left?
--One epilogue is being a sniper

--Sample of weights for 80's song

--Gongish Sound for failing
--French voice (female/male?)

--TALLY
--Idle Sounds
-- plink sound easter egg
--Tuning orchestra, background fades to black
--Workout Song/Orchestra, song speeds up as the timer goes on
--Gymnopedie
--one percent chance of meat punching bag
--clock starts as clock turns into heart
-- Gymnopedie
-- Random amount of zoom time and amount

--Pseudo Haptic shake on adding a weight

-- SOUNDS - adding weights, do an adding weight sound
-- ticking clock sound for adding time

--Air horns

--Sound is idle gym sounds -> orchestra tuning as 3 2 1, then like fast orchestra song
--If fail, pause, drop weights, hard cut to letterbox reflecting

function g3NewImage(filePath)
	return lg.newImage("minigames/lb/assets/"..filePath)
end

function g3NewSource(filePath)
	return la.newSource("minigames/lb/assets/"..filePath)
end
g3Vol = 1

function g3_load()

	lg.setBackgroundColor(100,100,100)
	simpleScale.updateScreen(800, 450,  SCREENWIDTH, SCREENHEIGHT)

	buff1 = g3NewImage("buff1.png")
	buff2 = g3NewImage("buff2.png")
	buff3 = g3NewImage("buff3.png")
	buff4 = g3NewImage("buff4.png")
	weight = g3NewImage("weight.png")
	buffrevelation = g3NewImage("buffrevelation.png")
	graduating1 = g3NewImage("graduating1.png")
	graduating2 = g3NewImage("graduating2.png")
	background = g3NewImage("background.png")
	clockmask = g3NewImage("clockmask.png")
	clockmaskinstructions = g3NewImage("clockmaskinstructions.png")
	mask2 = g3NewImage("mask2.png")
	dot = g3NewImage("dot.png")
	punchingbag = g3NewImage("punchingbag.png")
	fin = g3NewImage("fin.png")

	s_weight = g3NewSource("weight.mp3")
	s_remove_weight = g3NewSource("remove_weight.wav")
	s_remove_weight:setVolume(g3Vol-.5)
	s_idle = g3NewSource("idle.mp3")
	s_idle:setVolume(g3Vol+1.5)
	s_orchestra = g3NewSource("orchestra.mp3")
	s_orchestra:setVolume(g3Vol-.7)
	s_idle:setLooping(true)
	s_bell = g3NewSource("bell.wav")
	s_tick = g3NewSource("tick.mp3")
	s_tick:setVolume(g3Vol-.9)
	s_tick:setPitch(1.8)

	s_liftsong1 = g3NewSource("liftsong1.mp3")
	s_liftsong1:setVolume(g3Vol-.7)
	s_gymno = g3NewSource("gymno.mp3")
	s_explosion = g3NewSource("explosion.mp3")

	victorySounds = {g3NewSource("elephant.wav")}

	lbFont = lg.newFont("assets/fonts/munro.ttf", 20)
	lbWrongFont = lg.newFont("assets/fonts/munro.ttf", 80)
	revelationFont = lg.newFont("assets/fonts/Athelas.ttc", 30)
	lg.setFont(lbFont)

	sweat = {}

	sentences = {
		{"Memento Mori",}
		,
		{"I wonder if the chicken came before the egg...",}
		,
		{"From a certain point onward there is no longer any turning back. That is the point that must be reached.",}
		,
		{"Don't bend; don't water it down; don't try to make it logical; don't edit your own soul according to the fashion. Rather, follow your most intense obsessions mercilessly."}
		,
	}

	sentenceLinesHeight = {
		{1}
		,
		{1}
		,
		{2}
		,
		{3}
		,
	}

	numOfEpilogues = 1

	readytime = 1--330
	zoomtime = 375
	victorytime = 200
	fintime = 150
	zoomamount = 1.7
	revelationtime = 50
	darktime = 97
	epiloguetime = 240

	weightWobbleTime = 8

	player = {x = 400, y = 400, scale = 4}
	currentPlayer = 1
	rounds = 1---3


	strikes = true
	numOfStrikes = 100---2

	reset()
end

function reset()
	difficulty = 1
	weightWobbleTimer = 0
	time_difficulty = 30
	currentSentence = sentences[difficulty][math.random(#sentences[difficulty])]
	currentLinesHeight = sentenceLinesHeight[difficulty][math.random(#sentences[difficulty])]
	currentChar = 1
	currentTry = ""
	secondIntervals = 40
	secondDuration = 3000---30
	clock = 10*secondDuration
	clockbet = clock
	failure = false
	victory = false
	wrongchar = ""
	zoomy = 1
	epilogue = math.random(numOfEpilogues)

	timer = 0
	time = 0

	errorTally = 0

	player.im = buff1
	player.wordplace = 4
	weightDrawY = 0
	mode = 1

	rand1, rand2, rand3, rand4, rand5, rand6 = 0, 0, 0, 0, 0, 0
	s_idle:play()
	s_gymno:stop()
	s_bell:stop()
	s_explosion:stop()

	errorXs = {}
end


function nextTurn()
	reset()	
	currentPlayer = (currentPlayer%numOfPlayers) + 1
end


function addsweat(x, y)
	table.insert(sweat, {x=x, y=y, v=cu.floRan(-5,5),vv=cu.floRan(5,10), color = cu.floRan(-50,50), size = cu.floRan(6,9)})
end

function updatesweat()
	for i,v in ipairs(sweat) do
		v.x = v.x + v.v
		v.y = v.y - v.vv
		v.vv = v.vv-.3
	end
end

function drawsweat()
	for i,v in ipairs(sweat) do
		lg.setColor(170+v.color,170+v.color,255)
		lg.rectangle("fill", v.x, v.y, v.size, v.size)
	end
	lg.setColor(255,255,255)
end



function g3_textinput(t)	
	if not failure then
		if t == currentSentence:sub(currentChar, currentChar) then
			currentChar = currentChar + 1
			currentTry = currentTry..t
			for i = 0, currentChar, 10 do
				addsweat(player.x-15*player.scale+cu.floRan(-4,4), player.y-40*player.scale+cu.floRan(-4,4))
				addsweat(player.x+15*player.scale+cu.floRan(-4,4), player.y-40*player.scale+cu.floRan(-4,4))
			end
		elseif mode == 2 then
			if strikes and errorTally < numOfStrikes then
				ex = 150+lbFont:getWidth(currentTry)%(800-150*2)
				why = math.floor(lbFont:getWidth(currentTry)/(800-150*2))*lbFont:getLineHeight()
				table.insert(errorXs, {x = ex, y = why})
				errorTally = errorTally + 1

				currentTry = currentTry..currentSentence:sub(currentChar, currentChar)
				currentChar = currentChar + 1


			else
				failure = true
				wrongchar = t
			end
		end
	end
end

function g3_update()
	lg.setBackgroundColor(0,0,0)
	time = time + 1
	if mode == 1 then
		player.im = buff1
		if timer == 0 then
			if lk.isClick("up") and difficulty < #sentences then
				difficulty = difficulty + 1
				weightWobbleTimer = weightWobbleTime
				s_weight:setPitch(cu.floRan(.8,1.2))
				cu.repplay(s_weight)
			elseif lk.isClick("down") and difficulty > 1 then
				difficulty = difficulty - 1
				s_remove_weight:setPitch(cu.floRan(.8,1.2))
				cu.repplay(s_remove_weight)
			elseif lk.isClick("left") and time_difficulty > 2 then
				time_difficulty = time_difficulty - 1
				cu.repplay(s_tick)
			elseif lk.isClick("right") and time_difficulty < secondIntervals then
				time_difficulty = time_difficulty + 1
				cu.repplay(s_tick)
			elseif lk.isClick("return") and timer == 0 then
				currentSentence = sentences[difficulty][math.random(#sentences[difficulty])]
				currentLinesHeight = sentenceLinesHeight[difficulty][math.random(#sentences[difficulty])]
				clock = time_difficulty*secondDuration
				clockbet = clock
				timer = 1
				s_orchestra:play()
			end
		end
		if timer > 0 then
			timer = timer + 1

			if timer > readytime then
				mode = 2
				timer = 0
				zoomy = 1.1
			end
		end
	elseif mode == 2 then	
		s_idle:stop()
		s_orchestra:stop()
		s_liftsong1:play()
		player.im = buff1

		if currentChar >= #currentSentence/3 and currentChar <= #currentSentence*(2/3) then
			player.im = buff2
			weightDrawY = 34
			player.wordplace = 38
		elseif currentChar >= #currentSentence*(2/3) and currentChar <= #currentSentence then
			player.im = buff3
			player.wordplace = 65
			weightDrawY = 61
		elseif currentChar >= #currentSentence-1 then
			player.im = buff4
			victory = true
			s_explosion:play()
			for i = 1, difficulty do
				victorySounds[math.random(#victorySounds)]:play()
			end
			weightDrawY = 134
			mode = 4
			timer = 0
			for i = 1, difficulty*300 do
				addsweat(cu.floRan(100,700), 90+cu.floRan(-20,20))
			end
		end
		if not failure then
			updatesweat()

			clock = clock - 1
			if clock == 0 then
				failure = true
			end
		end


		if failure then
			s_liftsong1:stop()
			s_gymno:play()
			s_bell:play()
			if zoomy < zoomamount  then
				zoomy = zoomy + zoomamount/zoomtime
			else
				timer = timer + 1
				player.im = buffrevelation
				weightDrawY = 0
				if timer > revelationtime then
					mode = 3
					timer = 0
					g3_update()
				end
			end
		end
	elseif mode == 3 then
		timer = timer + 1

		if timer > epiloguetime+fintime then
			timer = 0
			nextTurn()
		end
	elseif mode == 4 then
		timer = timer + 1
		updatesweat()
		zoomy = 1
		if timer > victorytime then
			nextTurn()
		end
	end
end

function g3_draw()
	lg.push()
	lg.translate(-(((zoomy*800)-800)/2),-(((zoomy*(500-190))-(500-190))/2))
	lg.scale(zoomy, zoomy)
	if mode == 1 then
		lg.draw(background,0,0,0,4,4)
		lg.setColor(255,0,0,70)	
		lg.arc("fill", "pie", 181*4+2, 24*4+2, 60, -math.pi/2, (time_difficulty/(secondIntervals))*2*math.pi-math.pi/2, 1000)
		lg.setColor(0,0,0)	
		lg.draw(dot, 181*4+3, 24*4+2, (time_difficulty/(secondIntervals))*2*math.pi-math.pi, 2, 60)
		lg.setColor(255,255,255)
		lg.draw(clockmask,0,0,0,4,4)
		lg.setColor(255,255,255,math.min(255, time*3)-timer*5)
		lg.draw(clockmaskinstructions,0,0,0,4,4)
		cclear()
		lg.draw(punchingbag, 600, -10, math.sin(time/80)/30, 4, 4, 14, 0)
		lg.draw(mask2,0,0,0,4,4)


		swapPlayerColor(currentPlayer,"g")
		lg.draw(player.im,player.x,player.y,0,4,4,70.5, 80)
		unsetPlayerColor()

		if weightWobbleTimer ~= 0 then
			weightWobbleTimer = -weightWobbleTimer+cu.signOf(weightWobbleTimer)
		end
		for i = 1, difficulty do	
			if i == difficulty then		
				lg.draw(weight,player.x-28*4-(i*4*4),player.y-(3 + weightDrawY)*4,weightWobbleTimer/50,4,4,2, 8)
				lg.draw(weight,player.x+28*4+(i*4*4),player.y-(3 + weightDrawY)*4,weightWobbleTimer/50,4,4,2, 8)
			else
				lg.draw(weight,player.x-28*4-(i*4*4),player.y-(3 + weightDrawY)*4,0,4,4,2, 8)
				lg.draw(weight,player.x+28*4+(i*4*4),player.y-(3 + weightDrawY)*4,0,4,4,2, 8)
			end
		end

		lg.setColor(0,0,0,math.min(timer,170))
		lg.rectangle("fill",0,0,1000,1000)
		cclear()
	elseif mode == 2 then
		s_liftsong1:play()
		lg.draw(background,0,0,0,4,4)
		lg.setColor(255,0,0,70+rand1)	
		lg.arc("fill", "pie", 181*4+2, 24*4+2, 40, -math.pi/2, (((clock)/(secondIntervals*secondDuration)))*2*math.pi-math.pi/2, 1000)
		lg.setColor(0,0,0)	
		lg.draw(dot, 181*4+3, 24*4+2, (((clock)/(secondIntervals*secondDuration)))*2*math.pi-math.pi, 2, 40)lg.setColor(255,255,255)
		lg.draw(clockmask,0,0,0,4,4)
		lg.draw(punchingbag, 600, -10, math.sin(time/(80/currentChar))/(30/currentChar), 4, 4, 14, 0)
		lg.draw(mask2,0,0,0,4,4)


		lg.setColor(0,0,0,170)
		lg.rectangle("fill",0,0,1000,1000)
		cclear()

		--The Big Clock
		lg.setColor(255,0,0,70+rand1)	
		lg.arc("fill", "pie", 800/2, 450/2, 300+(clock%secondDuration)/4, -math.pi/2, (clock/clockbet)*2*math.pi-math.pi/2, 10000)
		lg.setColor(0,0,0)	
		lg.draw(dot, 800/2, 450/2, (clock/clockbet)*2*math.pi-math.pi, 2, 300+(clock%secondDuration)/4)
		lg.setColor(255,255,255)

		if clock%2 == 0 and not failure then
			rand1 = cu.floRan(-currentChar/150,currentChar/150)
			rand2 = cu.floRan(-currentChar/150,currentChar/150)
			rand3 = cu.floRan(-currentChar/150,currentChar/150)
			rand4 = cu.floRan(-currentChar/150,currentChar/150)
			rand5 = cu.floRan(-currentChar/150,currentChar/150)
			rand6 = cu.floRan(-currentChar/150,currentChar/150)
		elseif failure then
			rand1, rand2, rand3, rand4, rand5, rand6 = 0, 0, 0, 0, 0, 0
		end

		swapPlayerColor(currentPlayer,"g")
		if victory then
			lg.draw(buff4,player.x,player.y,0,4,4,70.5, 97)
		else
			lg.draw(player.im,player.x+rand5*7,player.y+rand6*7,0,4,4,70.5,80)
		end
		unsetPlayerColor()


		lg.setColor(255,255,255)
		for i = 1, difficulty do	
			lg.draw(weight,player.x-28*4-(i*4*4),player.y-(3+weightDrawY)*4,cu.floRan(-currentChar/80,currentChar/80),4,4,2, 8)
			lg.draw(weight,player.x+28*4+(i*4*4),player.y-(3+weightDrawY)*4,cu.floRan(-currentChar/80,currentChar/80),4,4,2, 8)
		end
		local wordHeight = 10*rand2+player.y-(player.wordplace*player.scale)-(currentLinesHeight+1)*lbFont:getHeight()
		lg.setColor(200,200,200)
		lg.printf(currentSentence, 150+rand1*10, wordHeight, 800-150*2, "left")
		lg.printf(currentSentence, 150+rand3*10, wordHeight, 800-150*2, "left")
		
		setPlayerColor(currentPlayer)
		lg.printf(currentTry, 150+rand1*10, wordHeight, 800-150*2, "left")
		lg.printf(currentTry, 150+rand3*10, wordHeight, 800-150*2, "left")
		
		lg.setColor(255,0,0)
		for i,v in ipairs(errorXs) do
			lg.print("/",v.x, wordHeight+v.y)
		end

		drawsweat()
	elseif mode == 3 then
		zoomy = 1
		if epilogue == 1 then
			if timer > darktime then
				lg.draw(graduating2,0,0,0,2.3,2.3)
				swapPlayerColor(currentPlayer,"g")
				lg.draw(graduating1,0,-40,0,2.3,2.3)
				unsetPlayerColor()
			end
		end
		if timer > epiloguetime then
			lg.draw(fin,0,0)
		end 
	elseif mode == 4 then
		rand1 = cu.floRan(-currentChar/80,currentChar/80)
		rand2 = cu.floRan(-currentChar/80,currentChar/80)

		s_liftsong1:stop()
		lg.draw(background,0,0,0,4,4)
		lg.setColor(255,0,0,70+rand1)	
		lg.arc("fill", "pie", 181*4+2, 24*4+2, 40, -math.pi/2, (((clock)/(secondIntervals*secondDuration)))*2*math.pi-math.pi/2, 1000)
		lg.setColor(0,0,0)	
		lg.draw(dot, 181*4+3, 24*4+2, (((clock)/(secondIntervals*secondDuration)))*2*math.pi-math.pi, 2, 40)
		lg.setColor(255,255,255)
		lg.draw(clockmask,0,0,0,4,4)
		lg.draw(punchingbag, 600, -10, math.sin(time/80)/30, 4, 4, 14, 0)
		lg.draw(mask2,0,0,0,4,4)

		swapPlayerColor(currentPlayer,"g")
		lg.draw(buff4,player.x+rand1,player.y+rand2,0,4.2,4.2,70.5, 97)
		unsetPlayerColor()


		lg.setColor(255,255,255)
		for i = 1, difficulty do	
			lg.draw(weight,player.x-28*4-(i*4*4),player.y-(3+weightDrawY)*4,cu.floRan(-currentChar/80,currentChar/80),4,4,2, 8)
			lg.draw(weight,player.x+28*4+(i*4*4),player.y-(3+weightDrawY)*4,cu.floRan(-currentChar/80,currentChar/80),4,4,2, 8)
		end


		drawsweat()
	end

	if mode ~= 3 and failure then
		lg.setFont(lbWrongFont)
		lg.setColor(255,0,0)
		lg.printf(wrongchar, player.x-200+cu.floRan(-1,1), player.y-380+cu.floRan(-1,1), 420, "center")	
		lg.setFont(lbFont)
	end
	lg.pop()
	if mode ~= 3 and failure then

		lg.setFont(revelationFont)
		if timer > 100 then
			lg.setColor(255,255,255)
			lg.printf("Dear god... what am I doing with my life...", 0, 350, 800, "center")
			lg.setColor(0,0,0)
			lg.printf("Dear god... what am I doing with my life...", 0+2, 350+2, 800, "center")
		end
		lg.setFont(lbFont)
	end
end