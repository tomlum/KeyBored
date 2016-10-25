pim_win={
	{im = lg.newImage("assets/im/player/scarfwin.png"), xoff = 150, yoff = 257},
	{im = lg.newImage("assets/im/player/bandywin.png"), xoff = 150, yoff = 256},
	{im = lg.newImage("assets/im/player/foxwin.png"), xoff = 150, yoff = 279},
	{im = lg.newImage("assets/im/player/sprinkledwin.png"), xoff = 150, yoff = 233}


}
pim = {
	{im = lg.newImage("assets/im/player/scarf.png"), xoff = 69.5, yoff = 273},
	{im = lg.newImage("assets/im/player/bandy.png"), xoff = 68.5, yoff = 266},
	{im = lg.newImage("assets/im/player/fox.png"), xoff = 116, yoff = 257},
	{im = lg.newImage("assets/im/player/sprinkled.png"), xoff = 86.5, yoff = 250}
}

im_playerpointer = lg.newImage("assets/im/playerpointer.png")
playerpointerfont = lg.newFont("assets/fonts/munro.ttf", 25)

playerColors = {
	{255,255,255,255},
	{20,200,20,255},
	{0,156,255,255},
	{230,169,90,255},
	{213,110,166,255}
}


function setPlayerColor(playerNum)
	local color = playerColors[playerNum+1]
	lg.setColor(color[1], color[2], color[3])
end

function swapPlayerColor(playerNum, c)
	if c == "g"	then
		colorSwap.send({nil, playerColors[playerNum+1]})
	elseif c == "m" then
		colorSwap.send({nil, nil, nil, nil, playerColors[playerNum+1]})
	end
	colorSwap.set()
end


function unsetPlayerColor()
	lg.setColor(255,255,255)
	colorSwap.unset()
end

function pimDraw(pim, x, y, scale)
	local scal = scale
	if scale == nil then
		scal = 1
	end
	lg.draw(pim.im, x, y, 0, scale, scale, pim.xoff, pim.yoff)
end