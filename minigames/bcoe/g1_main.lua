function g1NewImage(filePath)
	return lg.newImage("minigames/bcoe/assets/"..filePath)
end

function g1NewSource(filePath)
	return la.newSource("minigames/bcoe/assets/"..filePath)
end

require "minigames/bcoe/tricks"

function g1_load()
	simpleScale.setScreen(144, 90, 1200, 750, {fullscreen=false, vsync=true, msaa=0})
	im_skater = g1NewImage("skater.png")
	im_airskater = g1NewImage("airskater.png")
	im_board = g1NewImage("board.png")
	im_explosion = g1NewImage("explosion.png")
	im_airexplosion = g1NewImage("airexplosion.png")

	--Trees stuff
	im_trees = g1NewImage("trees.png")
	treesx = 0
	treespeed = 4
	treejumpspeed = 3
	im_background = g1NewImage("background.png")
	im_floor = g1NewImage("floor.png")
	meter = {
		x = 10,
		width = 4,
		dir = 1,
		speed = 3,
	}
	skater = {
		im = im_skater,
		y = 0
	}
	--Whether hte player has hit spacebar and jumped or not
	jump = false 
	jumptimer = 0
	fall = false
	hitkey = false

	scoretime = 20
	winningScore = 0
	currentScore = 0

	exploded = false

	explodedfont = lg.newFont("assets/fonts/munro.ttf", 30)
	trickfont = lg.newFont("assets/fonts/munro.ttf", 10)
	trickKey = ""
	alpha = "[qwertyuiopasdfghjklzxcvbnm]"
	
	g1_shuffleTricks()

	currentPlayer = 1
	trysLeft = 3
end

function g1_keypressed(key)
	if key ~= "space" and not exploded and string.match(key, alpha) and key:len() == 1 then
		hitkey = true
		trickKey = key
	end

end

function g1_update()
	--Move/Loop trees
	if treesx <= -140 then
		treesx = 0
	else 
		if jump then
			treesx = treesx - treejumpspeed
		else
			treesx = treesx - treespeed
		end
	end

	if exploded then 
		scoretime = 100000
		currentScore = 0
	end


	if jump then
		scoretime = 0
		if jumptimer > 0 then
			skater.im = im_airskater
			jumptimer = jumptimer - 1
			skater.y = skater.y - 1
		else
			fall = true
		end

		if fall then
			g1_doTrick()
			if skater.y >= 0 then
				fall = false
				jump = false
				trickKey = "efjiaoewjf"

				g1_shuffleTricks()
			end
			skater.y = skater.y + .1
		end
	else
		if scoretime < 20 then
			scoretime = scoretime + 1
			if scoretime == 20 then
				g1_nextTurn()
			end
		elseif scoretime < 100 then
			scoretime = scoretime + 1
		else
			if lk.isDown("space") then
				jump = true
				cu.repplay(trickSounds.jumpsound)
				currentScore = 0
				jumptimer = (1-math.abs(70-meter.x)/80)*20
			end

			--Move the Meter
			if meter.x + meter.dir*meter.speed > 140 or
				meter.x + meter.dir*meter.speed < 0 
				then
				meter.dir = -meter.dir
			end
			meter.x = meter.x + meter.dir*meter.speed
		end

		skater.im = im_skater


	end

	if not fall then 
		trick = nil
	end

	--Exploding
	if not fall and hitkey then 
		if not exploded then
			explodedtimer = 80
			cu.repplay(trickSounds.explosion)	
		end
		g1_nextTurn()
		exploded = true 
	end

	if exploded then 
		trickSounds.song:pause()
		explodedtimer = explodedtimer - 1
		if explodedtimer <= 0 then
			exploded = false
			trickSounds.song:play()
		end
		if jump then
			skater.im = im_airexplosion
		else
			skater.im = im_explosion
		end
	end

	if fade == 0 then
		mode = "RESULTS"
	end
end

function g1_nextTurn()

	if currentScore > winningScore then
		if winningScore > highscore then
			highscore = winningScore
		end
		winningScore = currentScore
		winner = currentPlayer
	end
	
	trysLeft = trysLeft - 1
	if trysLeft == 0 then
		if currentPlayer == numOfPlayers then
			fadeV = -3
		else
			trysLeft = 3
			currentPlayer = currentPlayer + 1
		end
	end
end

function g1_draw()
	simpleScale.transform()
	lg.setColor(255,255,255)
	lg.draw(im_background, 0, 0, 0, 1, 1)
	lg.draw(im_trees,treesx, 10, 0)
	g1_drawScoreBoard()
	lg.draw(im_floor, 0, 0)
	lg.setColor(0,0,0)
	lg.rectangle("fill",0, 81, 144, 100)
	lg.setColor(255,255,255)
	lg.rectangle("fill",meter.x, 81, meter.width, 9)
	lg.setColor(255,0,0)
	lg.rectangle("fill",69.5, 81, 1, 12)
	g1_drawScoreBoard()
	lg.setColor(255,255,255)


	swapPlayerColor(currentPlayer)
	if trick ~= nil then
		lg.draw(im_board, 0, skater.y)
		lg.draw(skater.im, 0, skater.y)
	else
		lg.draw(skater.im, 0, skater.y)
	end	
	unsetPlayerColor()

	if exploded then
		lg.setFont(explodedfont)
		lg.setColor(255,255,255)
		lg.printf("EXPLODED",0,20,140,"center")
		lg.setColor(0,0,0)
		lg.printf("EXPLODED",0,20-2,140-2,"center")
	end


	--Draw Score
	if scoretime < 100 and scoretime > 20 then
		local text = currentScore
		if currentPlayer == 1 and trysLeft == 3 then
			text = "GO!!!"
		end
		lg.setFont(explodedfont)
		if scoretime%20<9 then
			lg.setColor(0,0,0)
			lg.printf(text,0,20-10,140,"center")
			lg.setColor(255,255,255)
			lg.printf(text,0,20-1-10,140-1,"center")
		else
			lg.setColor(255,255,255)
			lg.printf(text,0,20-10,140,"center")
			lg.setColor(0,0,0)
			lg.printf(text,0,20-1-10,140-1,"center")
		end
	end

	lg.setFont(trickfont)
	lg.setColor(255,155,0)
	lg.setColor(playerColors[currentPlayer+1])
	lg.printf("Player "..currentPlayer, 2, -1, 80, "left")
	lg.printf("Trys Left "..trysLeft, 2, 7, 80, "left")
	hitkey = false
	simpleScale.letterBox()
end