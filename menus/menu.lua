--DROP BOOK, FROM MAX ZOOM, DUST FALLS
require "menus/title"
require "menus/select"
require "menus/results"
require "menus/pause"

--The last mode 
oldMode = "~"
--Initial hue for the title mode
backgroundHue= 0
--Fade amount
fade = 255
--Velocity of the fade
fadeV = 0


function menuSwitch()
  if mode == "TITLE" and oldMode ~= "TITLE" then
    fadeV = 4
  elseif mode == "SELECT" and oldMode ~= "SELECT" then
    bookDropScale = 50
    bookDust = {}
    fadeV = 3
    camera.y = 0
    game = 1
  elseif mode == "PLAY" and oldMode ~= "PLAY" then
    highscore = save.highscores[game]
    if game == 1 then
      g1_load()
    elseif game == 2 then
      g2_load()
    elseif game == 3 then
      g3_load()
    end
    fade = 255
  elseif mode == "RESULTS" and oldMode ~= "RESULTS"  then

    if highscore < winningScore then
      highscore = winningScore
    end
    save.highscores[game] = highscore
    love.filesystem.write("Save.lua", Tserial.pack(save))
    podiumY = height+250
    fireworks = {}
    fadeV = 3
  end
  oldMode = mode
end

function updateTitle()
  if lk.isDown("2") then
    numOfPlayers = 2
  elseif lk.isDown("3") then
    numOfPlayers = 3
  elseif lk.isDown("4") then
    numOfPlayers = 4
  end

  if lk.isDown("return") or (fadeV < 0) or fade == 0 then
    fadeV = -3
  end

  if fade <= 0 and fade == 0 then
    mode = "SELECT"
  end
end

function drawFade()
  --Update fade
  fade = fade + fadeV
  --Clamp the fade
  fade = math.max(0, math.min(fade, 255))
  if fade == 0 or fade == 255 then
    fadeV = 0
  end
  lg.setColor(0,0,0,255-fade)
  lg.rectangle("fill",-10,-10,width+20,height+20)
end