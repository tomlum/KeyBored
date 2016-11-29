save = {highscores = {0,0,0,0,0}}
--Get the highscores
if love.filesystem.exists("Save.lua") then
	newsave = Tserial.unpack(love.filesystem.read("Save.lua"))
	if #newsave == #save then
		save = newsave
	end
end
