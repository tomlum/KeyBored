im_podium = lg.newImage("assets/im/podium.png")

resultsFont = lg.newFont("assets/fonts/munro.ttf", 50)
resultsFont2 = lg.newFont("assets/fonts/munro.ttf", 30)

fireworkTimer = 0

function updateResults()
  --Make Fireworks
  if fireworkTimer > 40 then
    makeFirework(math.random(width))
    fireworkTimer = 0
  else
    fireworkTimer = fireworkTimer + 1
  end

  --Move Podium up
  if podiumY > 400 then
    podiumY = podiumY - 3
  else
    if lk.isDown("return") then
      fadeV = -3
    end
    if fade <= 0 then
      mode = "SELECT"
    end
  end
end

function drawResults()
  lg.setBackgroundColor(0,0,100)
  drawFireworks()
  lg.setColor(255,255,255)
  lg.draw(im_podium, width/4, podiumY, 0, 1, 1, 150, 50)
  pimDraw(pim_win[winner], width/4, podiumY+40)
  lg.setFont(resultsFont)
  lg.printf("PLAYER "..winner.."!", width/4-160, podiumY+80, 320, "center")
  if game == 1 then
    lg.setFont(resultsFont2)
    lg.printf(winningScore, width/4-160, podiumY+140, 320, "center")
    lg.printf("HIGHSCORE: "..highscore, width/4-160, podiumY+180, 320, "center")
    if winningScore == highscore then
      lg.printf("NEW HIGHSCORE!", width/4-160, podiumY+220, 320, "center")
    end
  end
end