--Adapted from cs.rit.edu
function HSB2RGB(h, s, v, a)
  h = (h/255)%1
  s = s/255
  v = v/255
  a = a/255
  local r,g,b
  local i
  local f, p, q, t
  if( s == 0 ) then
    r = v
    g = v
    b = v
    return {r*255,g*255,b*255,a*255}
  end
  h = h*6      
  i = math.floor( h )
  f = h - i      
  p = v * ( 1 - s )
  q = v * ( 1 - (s * f))
  t = v * ( 1 - (s * ( 1 - f )))
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
  elseif i >= 5 then
    r = v
    g = p
    b = q
  end
  return {r*255,g*255,b*255,a*255}
end

function hsl2rgb(h,s,l,a)

end

function hsl2rgb(h,s,l,a)
  local r, g, b

  if s == 0 then
    r, g, b = l, l, l -- achromatic
  else
    function hue2rgb(p, q, t)
      if t < 0   then t = t + 1 end
      if t > 1   then t = t - 1 end
      if t < 1/6 then return p + (q - p) * 6 * t end
      if t < 1/2 then return q end
      if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
      return p
    end

    local q
    if l < 0.5 then q = l * (1 + s) else q = l + s - l * s end
    local p = 2 * l - q

    r = hue2rgb(p, q, h + 1/3)
    g = hue2rgb(p, q, h)
    b = hue2rgb(p, q, h - 1/3)
  end

  return{r*255, g*255, b*255, a*255}
end

function cclear()
  lg.setColor(255,255,255)
end