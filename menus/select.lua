im_openBook = lg.newImage("assets/im/openBook.png")
im_openBookPictures = lg.newImage("assets/im/openBookPictures.png")
im_tablebackground = lg.newImage("assets/im/tablebackground.png")

im_key = lg.newImage("assets/im/key.png")
im_keypressed = lg.newImage("assets/im/keypressed.png")
im_spacebar = lg.newImage("assets/im/spacebar.png")
im_spacebarpressed = lg.newImage("assets/im/spacebarpressed.png")
im_instructionsbackground = lg.newImage("assets/im/instructionsbackground.png")
im_instructionsbackground1 = lg.newImage("assets/im/instructionsbackground1.png")
im_instructionsbackground2 = lg.newImage("assets/im/instructionsbackground2.png")
im_keyboard = lg.newImage("assets/im/keyboard2.png")

instructionFont = lg.newFont("assets/fonts/AmericanTypewriter.ttc", 18*1.5)
instructionFont:setLineHeight(1.14)

keyFont = lg.newFont("assets/fonts/munro.ttf", 30)
upSelectY = -height-50

function updateSelect()
  upSelectY = -height-50
  if bookDropScale > 5.2 then
    bookDropScale = bookDropScale - 1
    if bookDropScale <= 5.2 then
      bookDropScale = 5.2
      for i=0, 300 do
        local offset = cu.floRan(math.pi*20)
        table.insert(bookDust, {x = center.x+math.cos(offset)*400, y = center.y+math.sin(offset)*200, v = math.cos(offset)*cu.floRan(30), j = math.sin(offset)*cu.floRan(30), fade = math.random(255), shade = cu.floRan(100,200)})
      end
    end
  else
    --Up Mode
    if camera.y-camera.j <= upSelectY then
      camera.j = 0
      camera.y = upSelectY
      if lk.isDown("return") and game <= numOfGames then
        fadeV = -3
      end
      if lk.isDown("backspace") then
        camera.j = -20
      end
      if fade == 0 then
        MODE = "PLAY"
      end

      --Down Mode
    else
      --[[
      if mouse.x > center.x-62*bookDropScale and mouse.y > center.y-42*bookDropScale
        and mouse.x < center.x-10*bookDropScale and mouse.y < center.y-8*bookDropScale then
        game = 1 
      else 
        game = 0
      end
      ]]--

      if camera.y-camera.j >= 0 then
        camera.j = 0
        camera.y = 0
      end

      if lk.isClick("down") then
        game = 1+(game+1)%4
      elseif lk.isClick("up") then
        game = 1+(game-3)%4
      elseif lk.isClick("right") then
        if game <= 2 then
          game = 1+(game)%2
        elseif game <= 4 then
          game = 3+((game-2)%2)
        end
      elseif lk.isClick("left") then
        if game <= 2 then
          game = 1+(game-4)%2
        elseif game <= 4 then
          game = 3+((game-4)%2)
        end
      end

      if game > 0 and lk.isClick("return") and fade == 255 then
        if camera.y < upSelectY
          then
          camera.j = 0
          camera.y = upSelectY
        else
          camera.j = 20
        end
      elseif lk.isClick("backspace") then
        fadeV = -5
      end

      if fade == 0 and fadeV == 0 then
        MODE = "TITLE"
      end

      if game > 0 and lk.isClick("return") and fade == 255 then
        if camera.y < upSelectY
          then
          camera.j = 0
          camera.y = upSelectY
        else
          camera.j = 20
        end
      end
    end
  end
end

function drawSelect()
  camera:set()
  lg.setColor(hsl2rgb(backgroundHue,1,.85,1))
  lg.rectangle("fill",0,upSelectY,width,height*2+50)
  lg.setColor(255,255,255)    
  lg.draw(im_tablebackground,0,upSelectY,0,2,2)
  for i,dust in ipairs(bookDust) do
    dust.x = dust.x + dust.v
    dust.y = dust.y + dust.j
    dust.v = dust.v/1.05
    dust.j = dust.j/1.05
    dust.fade = math.max(dust.fade-5, 0)
    lg.setColor(dust.shade,dust.shade,dust.shade,dust.fade)
    lg.rectangle("fill", dust.x, dust.y, 50, 50)
    if dust.fade < 0 then
      table.remove(bookDust, i)
    end
  end 
  lg.setColor(255,255,255)
  lg.draw(im_openBook, center.x, center.y, 0, bookDropScale, bookDropScale, 100, 67.5)
  lg.setColor(255,255,0)
  if game == 1 then
    lg.rectangle("fill", center.x-64*bookDropScale, center.y-44*bookDropScale, 56*bookDropScale, 38*bookDropScale)
  elseif game == 2 then
    lg.rectangle("fill", center.x+64*bookDropScale, center.y-44*bookDropScale, -56*bookDropScale, 38*bookDropScale)
  elseif game == 3 then
    lg.rectangle("fill", center.x-64*bookDropScale, center.y+32*bookDropScale, 56*bookDropScale, -38*bookDropScale)
  elseif game == 4 then
    lg.rectangle("fill", center.x+64*bookDropScale, center.y+32*bookDropScale, -56*bookDropScale, -38*bookDropScale)
  end
  lg.setColor(255,255,255)
  lg.draw(im_openBookPictures, center.x, center.y, 0, bookDropScale, bookDropScale, 100, 67.5)

  if game == 1 then
    lg.setColor(255,255,255)
    lg.draw(im_instructionsbackground1,0,upSelectY,0,1.5,1.5)
    lg.setColor(0,0,0)
    lg.setFont(instructionFont)
    lg.printf("BE COOL OR EXPLODE\n\n   Players take turns attempting to perform the raddest combo trick.  \n   Press SPACEBAR to jump.  \n   While falling in the air, MASH KEYS to do tricks.  \n   If you attempt to do a trick as you're landing or while you're rising in the air, not only will \nyou not be cool, \nyou will \nEXPLODE"
      , 495*1.5, (25*1.5)+upSelectY, 280*1.5, "left"
      )
    lg.setColor(255,255,255)
    drawKeyboard(15, 330-height-74, 3.5, {
      q=1,
      w=1,
      e=1,
      r=1,
      t=1,
      y=1,
      u=1,
      i=1,
      o=1,
      p=1,
      a=1,
      s=1,
      d=1,
      f=1,
      g=1,
      h=1,
      j=1,
      k=1,
      l=1,
      z=1,
      x=1,
      c=1,
      v=1,
      b=1,
      n=1,
      m=1
      })
    drawKey("space", 207, upSelectY+50, 1)
  elseif game == 2 then
    lg.setColor(255,255,255)
    lg.draw(im_instructionsbackground2,0,upSelectY,0,1.5,1.5)
    lg.setColor(0,0,0)
    lg.setFont(instructionFont)
    lg.printf("THE ASCII ARTIST\n\n   Players take turns covertly selecting a word to draw with WASD and then drawing them using ONLY ASCII characters \n   Pressing SPACEBAR will lock in the drawing   \n   Then other players then place their guesses as to what the drawing was supposed to be using WASD  \n"
      , 495*1.5, (25*1.5)+upSelectY, 280*1.5, "left"
      )

    lg.setColor(255,255,255)
    drawKeyboard(15, upSelectY+15, 3, {
      w=1,
      a=1,
      s=1,
      d=1
      })

    lg.setColor(255,255,255)
    drawKeyboard(15, 330-height-74, 3, {
      accent = 1,
      one = 1,
      two = 1,
      three = 1,
      three = 1,
      four = 1,
      six = 1,
      seven = 1,
      eight = 1,
      nine = 1,
      zero = 1,
      minus = 1,
      equals = 1,
      lbracket = 1,
      rbracket = 1,
      backslash = 1,
      semicolon = 1,
      apostraphe = 1,
      comma = 1,
      period = 1,
      forwardslash = 1,
      space = 1
      })
  else
    lg.setColor(255,255,255)
    lg.draw(im_instructionsbackground1,0,upSelectY,0,1.5,1.5)
  end
  camera:unset()
end

keyboard = {}

function drawKey(key, x, y, size)
  lg.setColor(255,255,255)
  if key == "space" then
    if love.keyboard.isDown(key) then
      lg.draw(im_spacebarpressed, x, y, 0, size, size, 124, 27)
    else
      lg.draw(im_spacebar, x, y, 0, size, size, 124, 27)
    end
  else
    lg.setFont(keyFont)
    if love.keyboard.isDown(key) then
      lg.draw(im_keypressed, x, y, 0, size, size, 11, 9)
      lg.setColor(0,0,0)
      lg.printf(string.upper(key), x-9, y-6*size, 20, "center")
    else
      lg.draw(im_key, x, y, 0, size, size, 11, 9)
      lg.setColor(0,0,0)
      lg.printf(string.upper(key), x-9, y-8*size, 20, "center")
    end
  end
  lg.setColor(255,255,255)
end

function drawKeyboardKey(key,x,y,colorNum)
  if colorNum == nil then
    lg.setColor(176+20,176+20,135+20)
  else
    local color = playerColors[colorNum]
    if lk.isDown(key) then
      lg.setColor(color[1]/2, color[2]/2, color[3]/2)
    else
      lg.setColor(color[1], color[2], color[3])
    end
  end
  if key == "backspace" or key == "capslock" then
    lg.rectangle("fill", keyboard.x+x*keyboard.size, keyboard.y+y*keyboard.size, 14*keyboard.size, 7*keyboard.size)
  elseif key == "tab" then
    lg.rectangle("fill", keyboard.x+x*keyboard.size, keyboard.y+y*keyboard.size, 11*keyboard.size, 7*keyboard.size)
  elseif key == "return" then
    lg.rectangle("fill", keyboard.x+x*keyboard.size, keyboard.y+y*keyboard.size, 22*keyboard.size, 7*keyboard.size)
    lg.rectangle("fill", keyboard.x+(x+13)*keyboard.size, keyboard.y+(y-8)*keyboard.size, 9*keyboard.size, 15*keyboard.size)
  elseif key == "lshift" or key == "rshift" then
    lg.rectangle("fill", keyboard.x+x*keyboard.size, keyboard.y+y*keyboard.size, 21*keyboard.size, 7*keyboard.size)
  elseif key == "space" then
    lg.rectangle("fill", keyboard.x+x*keyboard.size, keyboard.y+y*keyboard.size, 49*keyboard.size, 7*keyboard.size)
  else
    lg.rectangle("fill", keyboard.x+x*keyboard.size, keyboard.y+y*keyboard.size, 7*keyboard.size, 7*keyboard.size)
  end
end

function drawKeyboard(x, y, size, keys)
  keyboard.x = x
  keyboard.y = y
  keyboard.size = size
  keyboard.keys =
  lg.setColor(176,176,135)
  lg.rectangle("fill",keyboard.x,keyboard.y,160*keyboard.size,49*keyboard.size)
  drawKeyboardKey("`",5,5,keys.accent)
  drawKeyboardKey("1",13,5,keys.one)
  drawKeyboardKey("2",13+8*1,5,keys.two)
  drawKeyboardKey("3",13+8*2,5,keys.three)
  drawKeyboardKey("4",13+8*3,5,keys.three)
  drawKeyboardKey("5",13+8*4,5,keys.four)
  drawKeyboardKey("6",13+8*5,5,keys.six)
  drawKeyboardKey("7",13+8*6,5,keys.seven)
  drawKeyboardKey("8",13+8*7,5,keys.eight)
  drawKeyboardKey("9",13+8*8,5,keys.nine)
  drawKeyboardKey("0",13+8*9,5,keys.zero)
  drawKeyboardKey("-",13+8*10,5,keys.minus)
  drawKeyboardKey("=",13+8*11,5,keys.equals)
  drawKeyboardKey("backspace",109,5,keys.backspace)
  drawKeyboardKey("tab",5,13,keys.tab)
  drawKeyboardKey("q",17,13,keys.q)
  drawKeyboardKey("w",17+8*1,13,keys.w)
  drawKeyboardKey("e",17+8*2,13,keys.e)
  drawKeyboardKey("r",17+8*3,13,keys.r)
  drawKeyboardKey("t",17+8*4,13,keys.t)
  drawKeyboardKey("y",17+8*5,13,keys.y)
  drawKeyboardKey("u",17+8*6,13,keys.u)
  drawKeyboardKey("i",17+8*7,13,keys.i)
  drawKeyboardKey("o",17+8*8,13,keys.o)
  drawKeyboardKey("p",17+8*9,13,keys.p)
  drawKeyboardKey("[",17+8*10,13,keys.lbracket)
  drawKeyboardKey("]",17+8*11,13,keys.rbracket)
  drawKeyboardKey("\\",17+8*12,13,keys.backslash)

  drawKeyboardKey("a",20,21,keys.a)
  drawKeyboardKey("s",20+8*1,21,keys.s)
  drawKeyboardKey("d",20+8*2,21,keys.d)
  drawKeyboardKey("f",20+8*3,21,keys.f)
  drawKeyboardKey("g",20+8*4,21,keys.g)
  drawKeyboardKey("h",20+8*5,21,keys.h)
  drawKeyboardKey("j",20+8*6,21,keys.j)
  drawKeyboardKey("k",20+8*7,21,keys.k)
  drawKeyboardKey("l",20+8*8,21,keys.l)
  drawKeyboardKey(";",20+8*9,21,keys.semicolon)
  drawKeyboardKey("'",20+8*10,21,keys.apostraphe)
  drawKeyboardKey("return",20+8*11,21,keys.enter)
  drawKeyboardKey("lshift",5,29,keys.lshift)
  drawKeyboardKey("z",25,29,keys.z)
  drawKeyboardKey("x",25+8*1,29,keys.x)
  drawKeyboardKey("c",25+8*2,29,keys.c)
  drawKeyboardKey("v",25+8*3,29,keys.v)
  drawKeyboardKey("b",25+8*4,29,keys.b)
  drawKeyboardKey("n",25+8*5,29,keys.n)
  drawKeyboardKey("m",25+8*6,29,keys.m)
  drawKeyboardKey(",",25+8*7,29,keys.comma)
  drawKeyboardKey(".",25+8*8,29,keys.period)
  drawKeyboardKey("/",25+8*9,29,keys.forwardslash)
  drawKeyboardKey("rshift",25+8*10,29,keys.rshift)
  drawKeyboardKey("space",36,37,keys.space)
  drawKeyboardKey("up",131+8,29,keys.up)
  drawKeyboardKey("left",131,37,keys.left)
  drawKeyboardKey("down",131+8,37,keys.down)
  drawKeyboardKey("right",131+16,37,keys.right)

  lg.setColor(255,255,255)
  lg.draw(im_keyboard,x,y,0,keyboard.size,keyboard.size)
end