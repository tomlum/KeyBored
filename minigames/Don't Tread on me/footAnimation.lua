--x and y function completely independently of each other

eye = lg.newImage("foot/googly.png")
function loadFoot()
	toe1 = {
		segments = {
			{rx = 37, ry = 80-5, pinx = 18, piny = 8, im = lg.newImage("foot/toe1seg1.png"), rotation = 0},
			{rx = 6, ry = 13, pinx = 16, piny = 10, im = lg.newImage("foot/toe1seg2.png"), rotation = 0}
		}
	}
	toe2 = {
		segments = {
			{rx = 37-4+2, ry = 80-10+2, pinx = 12, piny = 8, im = lg.newImage("foot/toe2seg1.png"), rotation = cu.floRan(-1,1)},
			{rx = 3, ry = 8, pinx = 18, piny = 11, im = lg.newImage("foot/toe2seg2.png"), rotation = cu.floRan(-1,1)}
		}
	}
	toe3 = {
		segments = {
			{rx = 37-2+2, ry = 80-18+2, pinx = 12, piny = 8, im = lg.newImage("foot/toe2seg1.png"), rotation = cu.floRan(-1,1)},
			{rx = 3, ry = 8, pinx = 18, piny = 11, im = lg.newImage("foot/toe2seg2.png"), rotation = cu.floRan(-1,1)}
		}
	}
	toe4 = {
		segments = {
			{rx = 37+2, ry = 80-18-7+2, pinx = 12, piny = 8, im = lg.newImage("foot/toe2seg1.png"), rotation = cu.floRan(-1,1)},
			{rx = 3, ry = 8, pinx = 18, piny = 11, im = lg.newImage("foot/toe2seg2.png"), rotation = cu.floRan(-1,1)}
		}
	}
	toe5 = {
		segments = {
			{rx = 37+2+2, ry = 80-18-7-6+2, pinx = 12, piny = 8, im = lg.newImage("foot/toe2seg1.png"), rotation = cu.floRan(-1,1)},
			{rx = 3, ry = 8, pinx = 18, piny = 11, im = lg.newImage("foot/toe2seg2.png"), rotation = cu.floRan(-1,1)}
		}
	}
	leg = lg.newImage("foot/leg.png")
	footRig = {im = lg.newImage("foot/footbase.png"), x = 400, y = 100, toes = {toe1, toe2, toe3, toe4, toe5}, pinx = 155, piny = 15, rotation = 0}
	rigtime = 0
	eye1 = {x=0,y=0,rot=0, rx = 72, ry=60}
	eye2 = {x=0,y=0,rot=0, rx = 102, ry=60}
end

function updateFoot()
	rigtime = rigtime + .1
	footRig.rotation = footRig.rotation + math.cos(rigtime)/100
	local dis = cu.dis(eye1.rx,eye1.ry,footRig.pinx,footRig.piny)
	local pinrot = math.atan((footRig.piny-eye1.ry)/(footRig.pinx-eye1.rx))
	eye1.x = footRig.x + math.cos(-footRig.rotation-pinrot)*dis*cu.signOf(eye1.rx-footRig.pinx)
	eye1.y = footRig.y + math.sin(-footRig.rotation-pinrot)*dis*cu.signOf(eye1.ry-footRig.piny)
	dis = cu.dis(eye2.rx,eye2.ry,footRig.pinx,footRig.piny)
	eye1.rot = eye1.rot+math.random()/2
	eye2.rot = eye2.rot-math.random()/2
	pinrot = math.atan((footRig.piny-eye2.ry)/(footRig.pinx-eye2.rx))
	eye2.x = footRig.x + math.cos(-footRig.rotation-pinrot)*dis*cu.signOf(eye2.rx-footRig.pinx)
	eye2.y = footRig.y + math.sin(-footRig.rotation-pinrot)*dis*cu.signOf(eye2.ry-footRig.piny)

	for i,toe in ipairs(footRig.toes) do
		for j,seg in ipairs(toe.segments) do
			seg.rotation = seg.rotation + math.cos(rigtime*(i+j)/2)/10
			if j == 1 then
				local dis = cu.dis(seg.rx,seg.ry,footRig.pinx,footRig.piny)
				local pinrot = math.atan((footRig.piny-seg.ry)/(footRig.pinx-seg.rx))
				seg.x = footRig.x + math.cos(-footRig.rotation-pinrot)*dis*cu.signOf(seg.rx-footRig.pinx)
				seg.y = footRig.y + math.sin(-footRig.rotation-pinrot)*dis*cu.signOf(seg.ry-footRig.piny)
			elseif j > 1 then
				local prevSeg = toe.segments[j-1]
				dis = cu.dis(prevSeg.pinx,prevSeg.piny,seg.rx,seg.ry)
				local pinrot = math.atan((prevSeg.piny-seg.ry)/(prevSeg.pinx-seg.rx))
				seg.x = prevSeg.x + math.cos(-prevSeg.rotation-pinrot)*dis*cu.signOf(seg.rx-prevSeg.pinx)
				seg.y = prevSeg.y + math.sin(-prevSeg.rotation-pinrot)*dis*cu.signOf(seg.ry-prevSeg.piny)
			end
		end
	end
end

function drawFoot(x, y)
	footRig.x = x
	footRig.y = y
	updateFoot()
	lg.draw(leg, footRig.x, footRig.y, footRig.rotation, 1, 1, 50, 904)
	lg.draw(footRig.im, footRig.x, footRig.y, footRig.rotation, 1, 1, footRig.pinx, footRig.piny)
	for i = #footRig.toes, 1, -1 do
		local toe = footRig.toes[i]
		for j,seg in ipairs(toe.segments) do
			lg.draw(seg.im, seg.x, seg.y, seg.rotation, 1, 1, seg.pinx, seg.piny)
		end
	end

	lg.draw(eye, eye1.x, eye1.y, eye1.rot, 1, 1, 12, 12)
	lg.draw(eye, eye2.x, eye2.y, eye2.rot, 1, 1, 12, 12)

	if math.random()>.5 then
		--footRig.y = footRig.y + math.sin(rigtime)*math.random(50)
	end
end