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


sweat = {}

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

buff1 = g3NewImage("buff1.png")
buff2 = g3NewImage("buff2.png")
buff3 = g3NewImage("buff3.png")
buff4 = g3NewImage("buff4.png")
buffrevelation = g3NewImage("buffrevelation.png")
graduating = g3NewImage("graduating.png")
background = g3NewImage("background.png")
clockmask = g3NewImage("clockmask.png")
clockmaskinstructions = g3NewImage("clockmaskinstructions.png")
dot = g3NewImage("dot.png")

function g3_load()
	lg.setBackgroundColor(100,100,100)
	simpleScale.setScreen(800, 500, 80, 50, {fullscreen=false, vsync=true, msaa=0})

	sentences = {
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
		{2}
		,
		{3}
		,
	}

	mode = 1
	currentPlayer = 1
	difficulty = 1
	time_difficulty = 30
	rounds = 3

	readytime = 130
	zoomtime = 100
	revelationtime = 80
	darktime = 70
	finishtime = 150


	zoomamount = 2


	player = {x = 400, y = 420, scale = 4}
	reset()

	lbFont = lg.newFont("assets/fonts/munro.ttf", 20)
	lbWrongFont = lg.newFont("assets/fonts/munro.ttf", 80)
	lg.setFont(lbFont)


end

function reset()
	currentSentence = sentences[difficulty][math.random(#sentences[difficulty])]
	currentLinesHeight = sentenceLinesHeight[difficulty][math.random(#sentences[difficulty])]
	currentChar = 1
	currentTry = ""
	secondIntervals = 40
	secondDuration = 30
	clock = 10*secondDuration
	failure = false
	wrongchar = ""
	zoomy = 1

	timer = 0

	player.im = buff1
	player.wordplace = 4
	mode = 1

	rand1, rand2, rand3, rand4, rand5, rand6 = 0, 0, 0, 0, 0, 0
end

function nextTurn()
	reset()
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
			failure = true
			wrongchar = t
		end
	end
end

function g3_update()

	if mode == 1 then
		player.im = buff1
		if lk.isClick("up") and difficulty < #sentences then
			difficulty = difficulty + 1
		elseif lk.isClick("down") and difficulty > 1 then
			difficulty = difficulty - 1
		elseif lk.isClick("left") and time_difficulty > 2 then
			time_difficulty = time_difficulty - 1
		elseif lk.isClick("right") and time_difficulty < secondIntervals then
			time_difficulty = time_difficulty + 1
		elseif lk.isClick("return") then
			currentSentence = sentences[difficulty][math.random(#sentences[difficulty])]
			currentLinesHeight = sentenceLinesHeight[difficulty][math.random(#sentences[difficulty])]
			clock = time_difficulty*secondDuration
			timer = 1
		end
		if timer > 0 then
			timer = timer + 1

			if timer > readytime then
				mode = 2
				timer = 0
			end
		end
	elseif mode == 2 then


		if currentChar >= #currentSentence/3 and currentChar <= #currentSentence*(2/3) then
			player.im = buff2
			player.wordplace = 38
		elseif currentChar >= #currentSentence*(2/3) and currentChar <= #currentSentence then
			player.im = buff3
			player.wordplace = 65
		elseif currentChar >= #currentSentence-1 then
			player.im = buff4
		end
		if not failure then
			updatesweat()

			clock = clock - 1
			if clock == 0 then
				failure = true
			end
		end


		if failure then
			if zoomy < zoomamount  then
				zoomy = zoomy + zoomamount/zoomtime
			else
				timer = timer + 1
				player.im = buffrevelation
				if timer > revelationtime then
					mode = 3
					timer = 0
				end
			end
		end
	elseif mode == 3 then
		timer = timer + 1

		if timer > finishtime then
			timer = 0
			nextTurn()
		end
	end
end

function g3_draw()
	simpleScale.transform()
	love.graphics.push()
	love.graphics.translate(-(((zoomy*800)-800)/2),-(((zoomy*(500-190))-(500-190))/2))
	love.graphics.scale(zoomy, zoomy)
	if mode == 1 then
		lg.draw(background,0,0,0,4,4)
		lg.setColor(255,0,0,70)	
		lg.arc("fill", "pie", 181*4+2, 24*4+2, 60, -math.pi/2, (time_difficulty/(secondIntervals))*2*math.pi-math.pi/2, 1000)
		lg.setColor(0,0,0)	
		lg.draw(dot, 181*4+2, 24*4+2, (time_difficulty/(secondIntervals))*2*math.pi-math.pi, 2, 60)
		lg.setColor(255,255,255)
		lg.draw(clockmask,0,0,0,4,4)
		lg.setColor(255,255,255,255-timer*5)
		lg.draw(clockmaskinstructions,0,0,0,4,4)
		cclear()

		lg.draw(player.im,player.x,player.y,0,4,4,70,80)
		setPlayerColor(currentPlayer)
		lg.printf(difficulty, 10, 10, 1000, "left")

		lg.setColor(0,0,0,math.min(timer,170))
		lg.rectangle("fill",0,0,1000,1000)
		cclear()
	elseif mode == 2 then
		lg.draw(background,0,0,0,4,4)
		lg.setColor(255,0,0,70+rand1)	
		lg.arc("fill", "pie", 181*4+2, 24*4+2, 40, -math.pi/2, (((clock/secondDuration)/(secondIntervals))-clock)*2*math.pi-math.pi, 1000)
		lg.setColor(0,0,0)	
		lg.draw(dot, 181*4+2, 24*4+2, (((clock/secondDuration)/(secondIntervals))-clock)*2*math.pi-math.pi, 2, 40)
		lg.setColor(255,255,255)
		lg.draw(clockmask,0,0,0,4,4)


		lg.setColor(0,0,0,170)
		lg.rectangle("fill",0,0,1000,1000)
		cclear()

		if clock%2 == 0 and not failure then
			rand1 = cu.floRan(-currentChar/80,currentChar/80)
			rand2 = cu.floRan(-currentChar/80,currentChar/80)
			rand3 = cu.floRan(-currentChar/80,currentChar/80)
			rand4 = cu.floRan(-currentChar/80,currentChar/80)
			rand5 = cu.floRan(-currentChar/80,currentChar/80)
			rand6 = cu.floRan(-currentChar/80,currentChar/80)
		elseif failure then
			rand1, rand2, rand3, rand4, rand5, rand6 = 0, 0, 0, 0, 0, 0
		end

		lg.draw(player.im,player.x+rand5*7,player.y+rand6*7,0,4,4,70,80)
		lg.setColor(200,200,200)
		lg.printf(currentSentence, 180+rand1*10, 10*rand2+player.y-(player.wordplace*player.scale)-(currentLinesHeight+1)*lbFont:getHeight(), 800-180, "left")
		lg.printf(currentSentence, 180+rand3*10, 10*rand4+player.y-(player.wordplace*player.scale)-(currentLinesHeight+1)*lbFont:getHeight(), 800-180, "left")
		setPlayerColor(currentPlayer)
		lg.printf(currentTry, 180+rand1*10, 10*rand2+player.y-(player.wordplace*player.scale)-(currentLinesHeight+1)*lbFont:getHeight(), 800-180, "left")
		lg.printf(currentTry, 180+rand3*10, 10*rand4+player.y-(player.wordplace*player.scale)-(currentLinesHeight+1)*lbFont:getHeight(), 800-180, "left")


		drawsweat()
	elseif mode == 3 then
		zoomy = 1
		lg.setBackgroundColor(0,0,0)
		if timer > darktime then
			lg.draw(graduating,0,0,0,2.3,2.3)
		end
	end

	if mode ~= 3 and failure then
		lg.setFont(lbWrongFont)
		lg.setColor(255,0,0)
		lg.printf(wrongchar, player.x-200+cu.floRan(-1,1), player.y-380+cu.floRan(-1,1), 420, "center")
		lg.setFont(lbFont)
	end
	love.graphics.pop()
	simpleScale.letterBox()
end