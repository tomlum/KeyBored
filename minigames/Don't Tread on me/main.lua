function love.load()
	--invisability powerup?
	lg = love.graphics
	lk = love.keyboard
	love.window.setMode(1440,900)
	math.randomseed(os.clock())
	lg.setDefaultFilter("linear","nearest",1)
	require "footAnimation"
	snakehead = lg.newImage("snakehead.png")
	snakebody = lg.newImage("snakebody.png")
	background = lg.newImage("background.png")
	gut = lg.newImage("guts.png")

	playerWidth = 30
	playerHeight = 40
	numOfPlayers = 4
	closestPlayer = 1
	playerDefault = {}
	playerDefault.width = 200
	playerDefault.friction = .5
	playerDefault.acceleration = .5
	playerDefault.speedLimit = 7
	players = {
		{color = {{1, 1, 0, 1}}, keys = {"q", "w"}, x = playerDefault.width*1.5+math.random(1440-playerDefault.width*1.5), v = 0, accel = playerDefault.acceleration, fric = playerDefault.friction, speedLimit = playerDefault.speedLimit, lr = 1, alive = true, width = playerDefault.width, lr = 1, animtimer = 1, im = snake1},
		{color = {{1, 0, 1, 1}}, keys = {"v", "b"}, x = playerDefault.width*1.5+math.random(1440-playerDefault.width*1.5), v = 0, accel = playerDefault.acceleration, fric = playerDefault.friction, speedLimit = playerDefault.speedLimit, lr = 1, alive = true, width = playerDefault.width, lr = 1, animtimer = 1, im = snake1},
		{color = {{0, 1, 1, 1}}, keys = {"i", "o"}, x = playerDefault.width*1.5+math.random(1440-playerDefault.width*1.5), v = 0, accel = playerDefault.acceleration, fric = playerDefault.friction, speedLimit = playerDefault.speedLimit, lr = 1, alive = true, width = playerDefault.width, lr = 1, animtimer = 1, im = snake1},
		{color = {{0, 0, 0, 1}}, keys = {"left", "right"}, x = playerDefault.width*1.5+math.random(1440-playerDefault.width*1.5), v = 0, accel = playerDefault.acceleration, fric = playerDefault.friction, speedLimit = playerDefault.speedLimit, lr = 1, alive = true, width = playerDefault.width, lr = 1, animtimer = 1, im = snake1}
	}

	foot = {width = 200, height = 100, y = 100, x = math.random(1440), v = 0, behavior = 0, xTimer = 0, lockSide = 1, stompTimer=200, stompAnimationTimer = 0, stompSpeed = 18}

	time = 0

	guts = {}

	function makeguts(ex,why,player)
		for i = 0, 20 do
			table.insert(guts, {x=ex, y=why, v = math.cos(cu.floRan(10))*cu.floRan(-10,10), j = math.abs(math.sin(cu.floRan(10))*cu.floRan(10)), t = 0, rot = cu.floRan(10), player = player})
		end
	end

	function updateguts()
		for i,v in ipairs(guts) do
			v.x = v.x + v.v
			v.y = v.y - v.j
			v.j = v.j - .2
			v.t = v.t + 1
			v.rot = v.rot + .1
			if v.t > 200 then
				table.remove(guts, i)
			end
		end
	end

	function drawguts()
		for i,v in ipairs(guts) do
			colorSwap.send(players[v.player].color)
			colorSwap.set()
			lg.draw(gut, v.x, v.y, v.rot,1,1,5,5)
		end
	end

	function foot.move()
		if foot.xTimer == 0 then
			foot.xTimer = math.random(50,150)
			foot.behavior = math.random(3)
			lockedPlayer = math.random(numOfPlayers)
		else
			foot.xTimer = foot.xTimer - 1
			if foot.behavior == 1 then
				foot.v = (players[closestPlayer].x-foot.x)/(20+math.abs(math.cos(foot.xTimer/(30-time/200)))*100)
			elseif foot.behavior == 2 then
				foot.v = (players[closestPlayer].x-foot.x)/(40-time/200)
			elseif foot.behavior == 3 then
				if foot.x > 1440 then foot.lockSide = -1
				elseif foot.x < 0 then foot.lockSide = 1
				end
				foot.x = cu.approach(players[lockedPlayer].x + 200*foot.lockSide, foot.x, 6)
			end
		end
	end

	function foot.stomp()
		foot.y = math.max(80, math.min(700, foot.y + foot.stompSpeed))

		if foot.y == 80 and foot.stompSpeed < 0 then
			foot.stompSpeed = -foot.stompSpeed
			foot.stompTimer = math.random(50,math.max(100, 600-time/5))
			foot.stompSpeed = foot.stompSpeed + 2
		end
		if foot.y == 700  then
			foot.stompSpeed = -foot.stompSpeed
		end

	end
	loadFoot()
end

function love.update()
	time = time+1
	updateguts()
	for i,player in ipairs(players) do
		if player.alive then
			closestPlayer = i
		end
	end
	for i,player in ipairs(players) do
		if player.alive and math.abs(player.x-foot.x) < math.abs(players[closestPlayer].x-foot.x) then
			closestPlayer = i
		end
	end



	if foot.stompTimer == 0 then
		foot.stomp()
	else 
		foot.stompTimer = foot.stompTimer - 1
		foot.move()
		foot.x = foot.x + foot.v
	end


	for i,player in ipairs(players) do
		if player.alive then
			if lk.isDown(player.keys[1]) then
				player.animtimer = (player.animtimer + 1)
				player.lr = -1
				if player.v > -player.speedLimit then
					player.v = player.v - player.accel
				end
			elseif lk.isDown(player.keys[2]) then
				player.animtimer = (player.animtimer + 1)
				player.lr = 1
				if player.v < player.speedLimit then
					player.v = player.v + player.accel
				end
			else
				player.v = cu.approach(0, player.v, player.fric)
			end

			if player.x + player.v + player.width/2 < 1440 and player.x + player.v - player.width/2 > 0 then
				player.x = player.x + player.v
			end

			if math.abs(player.x+70 - foot.x) < foot.width/2+player.width/2 and foot.y >= 450 then
				player.alive = false
				for j = -10, 10 do
					makeguts(player.x+j,700+cu.floRan(-10,10),i)
					--table.insert(chunks, {x = player.x + i, y = player.y, v = cu.floRan(), j= cu.floRan()})
				end
			end
		end
	end
end

function love.draw()
	lg.setColor(255,255,255)
	lg.draw(background,0,0)
	--lg.rectangle("line", foot.x-foot.width/2, foot.y,foot.width, -foot.height)
	drawguts()
	for i,player in ipairs(players) do
		if player.alive then
			colorSwap.send(player.color)
			colorSwap.set()
			--lg.setColor(player.color[1],player.color[2],player.color[3])
			lg.draw(snakehead, player.x+87+87*player.lr, 900-20,0,player.lr,1,0,300)
			lg.draw(snakebody, player.x+87+87*player.lr, 900-20,0,player.lr+(math.cos(player.animtimer/5)/6),1,237,300)
			--lg.rectangle("line", player.x+70-player.width/2, 800-20,player.width,-playerHeight)
		end
	end
	drawFoot(foot.x+50, foot.y-80)
end