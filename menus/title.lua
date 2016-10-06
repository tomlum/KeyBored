im_title = lg.newImage("assets/im/title.png")
titleFont = lg.newFont("assets/fonts/munro.ttf", 30)

function drawTitle()
  lg.setColor(hsl2rgb(backgroundHue,1,.85,1))
  lg.rectangle("fill",0,0,width,height)
  lg.setColor(255,255,255)    
  lg.draw(im_title,0,0,0,6,6)
  lg.setFont(playerpointerfont)
  if numOfPlayers == 2 then
    lg.setColor(playerColors[2])
    lg.printf("P1",width*1/3-20,130,40,"center")
    lg.draw(im_playerpointer,width*1/3,160,0,1,1,19)

    lg.setColor(playerColors[3])
    lg.printf("P2",width*2/3-20,130,40,"center")
    lg.draw(im_playerpointer,width*2/3,160,0,1,1,19)

    cclear()
    pimDraw(pim[1],width*1/3,504)
    pimDraw(pim[2],width*2/3,504)
elseif numOfPlayers == 3 then
    lg.setColor(playerColors[2])
    lg.printf("P1",width*1/4-20,130,40,"center")
    lg.draw(im_playerpointer,width*1/4,160,0,1,1,19)

    lg.setColor(playerColors[3])
    lg.printf("P2",width*2/4-20,130,40,"center")
    lg.draw(im_playerpointer,width*2/4,160,0,1,1,19)

    lg.setColor(playerColors[4])
    lg.printf("P3",width*3/4-20,130,40,"center")
    lg.draw(im_playerpointer,width*3/4,160,0,1,1,19)

    cclear()
    pimDraw(pim[1],width*1/4,504)
    pimDraw(pim[2],width*2/4,504)
    pimDraw(pim[3],width*3/4,504)
elseif numOfPlayers == 4 then
    lg.setColor(playerColors[2])
    lg.printf("P1",width*1/5-20,130,40,"center")
    lg.draw(im_playerpointer,width*1/5,160,0,1,1,19)

    lg.setColor(playerColors[3])
    lg.printf("P2",width*2/5-20,130,40,"center")
    lg.draw(im_playerpointer,width*2/5,160,0,1,1,19)

    lg.setColor(playerColors[4])
    lg.printf("P3",width*3/5-20,130,40,"center")
    lg.draw(im_playerpointer,width*3/5,160,0,1,1,19)

    lg.setColor(playerColors[5])
    lg.printf("P4",width*4/5-20,130,40,"center")
    lg.draw(im_playerpointer,width*4/5,160,0,1,1,19)

    cclear()
    pimDraw(pim[1],width*1/5,504)
    pimDraw(pim[2],width*2/5,504)
    pimDraw(pim[3],width*3/5,504)
    pimDraw(pim[4],width*4/5,504)
end
lg.setFont(titleFont)
lg.setColor(hsl2rgb(1-backgroundHue,1,.2,1))
lg.printf("SELECT NUMBER OF PLAYERS", center.x-100, 20, 200, "center")
end