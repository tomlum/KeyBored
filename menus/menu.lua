--DROP BOOK, FROM MAX ZOOM, DUST FALLS
require "menus/title"
require "menus/select"
require "menus/results"
require "menus/pause"

--The last MODE 
oldMode = "~"
--Initial hue for the title MODE
backgroundHue= 0
--Fade amount
fade = 255
--Velocity of the fade
fadeV = 0


function menuSwitch()
  if MODE == "TITLE" and oldMode ~= "TITLE" then
    simpleScale.setScreen(1200, 675, SCREENWIDTH, SCREENHEIGHT, {fullscreen=FULLSCREEN, vsync=true, msaa=0})
    fadeV = 4
  elseif MODE == "SELECT" and oldMode ~= "SELECT" then
    simpleScale.updateScreen(1200, 675)
    bookDropScale = 50
    bookDust = {}
    fadeV = 3
    camera.y = 0
    game = 1
  elseif MODE == "PLAY" and oldMode ~= "PLAY" then
    highscore = save.highscores[game]
    loadGames()
    fade = 255
  elseif MODE == "RESULTS" and oldMode ~= "RESULTS"  then
    simpleScale.updateScreen(1200, 675)
    if highscore < winningScore then
      highscore = winningScore
    end
    save.highscores[game] = highscore
    love.filesystem.write("Save.lua", Tserial.pack(save))
    podiumY = height+250
    fireworks = {}
    fadeV = 3
  end
  oldMode = MODE
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
    MODE = "SELECT"
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