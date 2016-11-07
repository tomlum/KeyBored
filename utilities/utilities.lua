--Handy Shortcuts
lg = love.graphics
lk = love.keyboard
la = love.audio
lm = love.mouse
lw = love.window

require "utilities/Tserial"
require "utilities/camera"
require "utilities/hsb"
require "utilities/colorSwap"
require "utilities/simpleScale"
require "utilities/commonUtilities"
require "utilities/effects"

function lk.isClick(key)
	return clickKey == key
end

function updateClick1(key)
	clickKey = key
end

function updateClick2()
	clickKey = nil
end

function updateCoords()

	width = 1200
	height = 675

	center = {x = width/2, y = height/2}
end

mouse = {}
function updateMouse()
	mouse.x = lm.getX()
	mouse.y = lm.getY()
	mouse.click = lm.isDown(1)
end

updateCoords()