--Establish the name space
cu = {}

--Distance between two points {x1, y1} {x2, y2}
function cu.dis(x1, y1, x2, y2)
	return math.sqrt((x1-x2)^2 + (y1-y2)^2)
end

--Distance between two points {x = x1, y = y1} {x = x2, y = y2}
function cu.pDis(p1, p2)
	return math.sqrt((p1.x-p2.x)^2 + (p1.y-p2.y)^2)
end

--Shuffles the items in a table
function cu.shuffle(t)
	local j
	for i = #t, 2, -1 do
		j = math.random(i)
		t[i], t[j] = t[j], t[i]
	end
end

--Flips a coin, if heads return 1, if tails return -1
function cu.flip()
	if math.random() > .5 then
		return 1
	else
		return -1
	end
end

--Good for sound effects
--If the sound effect is in the middle of being played it resets it
function cu.repplay(sound)
	if sound:isStopped() then
		sound:play()
	else
		sound:rewind()
		sound:play()
	end
end

--Returns current +/- delta, unless it passes or is current, 
--at which point it returns current
function cu.approach(goal, current, delta)
	if current > goal then
		local new = goal - delta

		if new <= goal then
			return goal
		else
			return new
		end
	elseif current < goal then
		local new = goal + delta
		
		if new >= goal then
			return goal
		else
			return new
		end
	else
		return goal
	end
end

--Generate a float random
function cu.floRan(low,up)
	if up == nil then
		return math.random()*(low)
	else
		return low+math.random()*(up-low)
	end
end

--Returns 1 for a positive number and -1 for a negative number or 0 for zero
function cu.signOf(n)
	if n > 0 then
		return 1
	elseif n < 0 then
		return -1
	else
		return n
	end
end

--Adapted from cs.rit.edud
function HSB2RGB(h, s, v, a)

	local r,g,b
	local i
	local f, p, q, t
	if( s == 0 ) then
		r = v
		g = v
		b = v
		return {r,g,b,a}
	end
	h = h*6      
	i = math.floor( h )
	f = h - i      
	p = v * ( 1 - s )
	q = v * ( 1 - s * f )
	t = v * ( 1 - s * ( 1 - f ) )
	if i == 0 then
		r = v
		g = t
		b = p
	elseif i == 1 then
		r = q
		g = v
		b = p
	elseif i == 2 then
		r = p
		g = v
		b = t
	elseif i == 3 then
		r = p
		g = q
		b = v
	elseif i == 4 then
		r = t
		g = p
		b = v
	elseif i == 5 then
		r = v
		g = p
		b = q
	end
	return {r,g,b,a}
end

--Array substring
getmetatable('').__index = function(str,i)
	if type(i) == 'number' then
		return string.sub(str,i,i)
	else
		return string[i]
	end
end