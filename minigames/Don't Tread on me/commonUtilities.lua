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

function cu.signOf(num)
	if num > 0 then
		return 1
	elseif num < 0 then
		return -1
	else 
		return 0
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

--Generate a float random
function cu.floRan(low,up)
	if up == nil then
		return math.random()*(low)
	else
		return low+math.random()*(up-low)
	end
end

function cu.clone (t) -- deep-copy a table
    if type(t) ~= "table" then return t end
    local meta = getmetatable(t)
    local target = {}
    for k, v in pairs(t) do
      if type(v) == "table" then
        target[k] = clone(v)
      else
        target[k] = v
      end
    end
    setmetatable(target, meta)
    return target
  end

--Array substring
getmetatable('').__index = function(str,i)
	if type(i) == 'number' then
		return string.sub(str,i,i)
	else
		return string[i]
	end
end

--Returns current +/- delta, unless it passes or is current, 
--at which point it returns current
function cu.approach(goal, current, delta)
	if current > goal then
		local new = current - delta

		if new <= goal then
			return goal
		else
			return new
		end
	elseif current < goal then
		local new = current + delta
		
		if new >= goal then
			return goal
		else
			return new
		end
	else
		return goal
	end
end