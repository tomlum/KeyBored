function love.load()
	
	SCREENWIDTH = 16*70
	SCREENHEIGHT = 9*70
	FULLSCREEN = false

	--Game Initializers
	require "utilities/utilities"
	math.randomseed(os.clock())
	require "menus/menu"
	require "players"
	require "minigames/minigames"

	love.window.setMode(SCREENWIDTH, SCREENHEIGHT, {fullscreen=FULLSCREEN, vsync=true, msaa=0})

	------------------------
	--USEFUL DEBUG GLOBALS--
	------------------------
	debug = false
	--TITLE -> SELECT -> PLAY -> RESULTS
	MODE = "TITLE"
	game = 3
	la.setVolume(0)
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
	simpleScale.transform()	
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

	simpleScale.letterBox()

	if debug then
		lg.print("MODE: "..MODE, 10, 10)
		lg.print("fade: "..fade, 10, 40)
		lg.print("fadeV: "..fadeV, 10, 70)
	end
end