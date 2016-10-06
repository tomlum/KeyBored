function love.load()

	--Game Initializers
	require "utilities/utilities"
	la.setVolume(0)
	lw.setMode(1200,750)
	math.randomseed(os.clock())
	lg.setDefaultFilter("linear","nearest",1)
	require "menus/menu"
	require "players"
	require "minigames/minigames"


	------------------------
	--USEFUL DEBUG GLOBALS--
	------------------------
	debug = false
	mode = "TITLE"
	--TITLE -> SELECT -> PLAY -> RESULTS
	game = 4
	------------------------
	------------------------


	--------------------------
	--USEFUL IN-GAME GLOBALS--
	--------------------------
	numOfPlayers = 2
	winner = 1
	--------------------------
	--------------------------

	winningScore = 0
	highscore = 0
end

function love.keypressed(key)
	updateClick1(key)
	if mode == "PLAY" then
		keypressGames(key)
	end
end

function love.textinput(t)
	if mode == "PLAY" then
		textinputGames(t)
	end
end

function love.update()
	updateCoords()
	updateMouse()
	updatePause()
	menuSwitch()
	backgroundHue = (backgroundHue + .002)%1

	if not pause then
		if mode == "TITLE" then
			updateTitle()
		elseif mode == "SELECT" then
			updateSelect()
		elseif mode == "PLAY" then
				update_games()
		elseif mode == "RESULTS" then
			updateResults()
		end
	end
	menuSwitch()
	updateClick2()
end

function love.draw()
	updateCamera()
	if mode == "TITLE" then
		drawTitle()
	elseif mode == "SELECT" then
		drawSelect()
	elseif mode == "PLAY" then
		drawGames()
		if fade <= 0 then
			mode = "RESULTS"
		end
	elseif mode == "RESULTS" then
		drawResults()
	end

	drawFade()
	drawPause()

	if debug then
		lg.print("mode: "..mode, 10, 10)
		lg.print("fade: "..fade, 10, 40)
		lg.print("fadeV: "..fadeV, 10, 70)
	end
end