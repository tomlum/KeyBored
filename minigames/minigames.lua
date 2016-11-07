require "minigames/bcoe/g1_main"
require "minigames/ascii/g2_main"
require "minigames/lb/g3_main"
require "minigames/wntt/g4_main"
require "minigames/ams/g5_main"

numOfGames = 5
save = {highscores = {0,0,0,0,0}}
--Get the highscores
if love.filesystem.exists("Save.lua") then
	newsave = Tserial.unpack(love.filesystem.read("Save.lua"))
	if #newsave == #save then
		save = newsave
	end
end

function keypressGames(key)
	if game == 1 then
		g1_keypressed(key)
	elseif game == 2 then
		g2_keypressed(key)
	end
end

function textinputGames(t)
	if game == 2 then
		g2_textinput(t)
	elseif game == 3 then
		g3_textinput(t)
	end
end

function loadGames()
	if game == 1 then
		g1_load()
	elseif game == 2 then
		g2_load()
	elseif game == 3 then
		g3_load()
	elseif game == 4 then
		g4_load()
	elseif game == 5 then
		g5_load()
	end
end

function updateGames()
	if game == 1 then
		g1_update()
	elseif game == 2 then
		g2_update()
	elseif game == 3 then
		g3_update()
	elseif game == 4 then
		g4_update()
	elseif game == 5 then
		g5_update()
	end
end

function drawGames()
	if game == 1 then
		g1_draw()
	elseif game == 2 then
		g2_draw()
	elseif game == 3 then
		g3_draw()
	elseif game == 4 then
		g4_draw()
	elseif game == 5 then
		g5_draw()
	end
end
