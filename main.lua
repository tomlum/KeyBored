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
	--TITLE -> SELECT -> PLAY -> RESULTS
	MODE = "PLAY"
	game = 5
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
	if MODE == "PLAY" then
		keypressGames(key)
	end
end

function love.textinput(t)
	if MODE == "PLAY" then
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
		if MODE == "TITLE" then
			updateTitle()
		elseif MODE == "SELECT" then
			updateSelect()
		elseif MODE == "PLAY" then
				updateGames()
		elseif MODE == "RESULTS" then
			updateResults()
		end
	end
	menuSwitch()
	updateClick2()
end

function love.draw()
	updateCamera()
	if MODE == "TITLE" then
		drawTitle()
	elseif MODE == "SELECT" then
		drawSelect()
	elseif MODE == "PLAY" then
		drawGames()
		if fade <= 0 then
			MODE = "RESULTS"
		end
	elseif MODE == "RESULTS" then
		drawResults()
	end

	drawFade()
	drawPause()

	if debug then
		lg.print("MODE: "..MODE, 10, 10)
		lg.print("fade: "..fade, 10, 40)
		lg.print("fadeV: "..fadeV, 10, 70)
	end
end