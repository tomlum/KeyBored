fireworkColor = {255,255,0}
function makeFirework(ex)
	table.insert(fireworks, {x = ex, y = height, stopY = math.random(height/3)+50})
end

function drawFireworks()
	--lg.rectangle("fill",10,10,10,10)
	for i,v in ipairs(fireworks) do
		if v.sparks == nil then
			v.y = v.y - 10 + (200-math.min(v.y-v.stopY,200))/21
			lg.setColor(fireworkColor)
			lg.rectangle("fill", v.x, v.y, 4,4)
			if v.y < v.stopY then
				v.sparks = {}
				v.trails = {}
				for i=0, 80 do 
					local rot = cu.floRan(2*math.pi)
					local dis = cu.floRan(1)
					table.insert(v.sparks, {x = v.x, y = v.y, v = math.cos(rot)*dis, j = math.sin(rot)*dis, time = 0})
				end
			end
		else
			for j,spark in ipairs(v.sparks) do
				spark.x = spark.x + spark.v
				spark.y = spark.y + spark.j
				spark.j = spark.j + cu.floRan(.01)
				lg.setColor(fireworkColor)
				spark.time = spark.time + 1
				if spark.time%4 == 0 then
					table.insert(v.trails, {x = spark.x, y = spark.y, fade = 255-spark.time*1})
				end
				if spark.time > 255 then
					table.remove(v.sparks, j)
				end
			end

			for j,trail in ipairs(v.trails) do
				trail.fade = trail.fade - 3
				lg.setColor(fireworkColor[1], fireworkColor[2], fireworkColor[3], trail.fade)
				lg.rectangle("fill", trail.x, trail.y, 2,2)
				if trail.fade < 0 then
					table.remove(v.trails, j)
				end
			end
		end
	end
end