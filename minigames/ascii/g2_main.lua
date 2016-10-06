--Music speeds up, or just pitch increases, easier, and can transition from the selection
function g2_load()
	filePath = "minigames/ascii/"

	function g2NewFont(font, size)
		lg.newFont(minigames/ascii/assets..font, size)
	end
	Text = require ("minigames/ascii/Text")

	simpleScale.setScreen(800, 500, 1200, 750, {fullscreen=false, vsync=true, msaa=0})

	lg.setDefaultFilter("linear","nearest",1)
	fontSize = 80
	fonts = {
		g2NewFont("1.ttc", fontSize),
		g2NewFont("2.ttc", fontSize),
		g2NewFont("3.ttc", fontSize),
		g2NewFont("4.ttf", fontSize),
		g2NewFont("5.ttf", fontSize),
		g2NewFont("6.ttc", fontSize),
		g2NewFont("7.ttc", fontSize),
		g2NewFont("8.ttc", fontSize)
	}
	phraseFonts = {
		g2NewFont("1.ttc", fontSize/3),
		g2NewFont("2.ttc", fontSize/3),
		g2NewFont("3.ttc", fontSize/3),
		g2NewFont("4.ttf", fontSize/3),
		g2NewFont("5.ttf", fontSize/3),
		g2NewFont("6.ttc", fontSize/3),
		g2NewFont("7.ttc", fontSize/3),
		g2NewFont("8.ttc", fontSize/3)
	}
	lg.setFont(fonts[2])
	char = ""
	key = ""
	mode = "select"
	groups = {
		{"UFO", "Plate", "Hat", "Donut"},
		{"Car", "Bus", "Truck", "RV"},
		{"Police Officer", "Librarian", "Construction Worker", "Fireman"}
	}
	votePhrases = {"Well... What is it?"}
	theGroup = 1
	theWord = 0
	canvas = ""
	rot = 99

	artist = 1
	guesser = 2
	scores = {0, 0, 0, 0}

	g2_update()
end

function g2_keypressed(k)
	if mode == "select" then
		if k == "w" then
			theWord = 1
		elseif k == "a" then
			theWord = 2
		elseif k == "s" then
			theWord = 3
		elseif k == "d" then
			theWord = 4
		end

		if theWord ~= 0 then
			mode = "draw"
			local num = math.random(#fonts)
			canvasFont = fonts[num]
			phraseFont = phraseFonts[num]
		end
	end
end

function g2_textinput(t)	
	if mode == "draw" then
		if not (t:match("%a")) then
			char = t
		end
	end
end

function g2_update(dt)

	rot = rot + 1
	if mode == "select" then
		if rot%100 == 0 then
			font1 = fonts[math.random(#fonts)]
			font2 = fonts[math.random(#fonts)]
			font3 = fonts[math.random(#fonts)]
			font4 = fonts[math.random(#fonts)]
		end
	elseif mode == "draw" then
		phraseY = 0

		if #char == 1 or char == " " then
			num, lines = canvasFont:getWrap(canvas..char, 800)
			if #lines*canvasFont:getHeight() > 500 or char == " " then
				mode = "vote"
				votePhrase = Text(0, 0, '['..votePhrases[math.random(#votePhrases)]..'](move)', {
				font = phraseFont,
				wrap_width = 300,
				align_ceter = true,
				move = function(dt, c)
					c.x = c.x + math.cos(rot/10+(10+c.position)%10)/8
					c.y = c.y + math.sin(rot/10+(10+c.position)%10)/8
				end
				})
			else
				canvas = canvas..char
			end
		end
		canvasScale = 1
		char = ""

	elseif mode == "vote" then
		if phraseY < 300 then
			phraseY = phraseY + 1
		end
		votePhrase:update(dt)
		if canvasScale > 2/3 then
			canvasScale = canvasScale - 1/900
		end

		while guesser < numOfPlayers do
			if lk.isDown("w") then
				if (theWord == 1) then
					scores[guesser] = scores[guesser] + 1
				end
				guesser = guesser + 1

			elseif lk.isDown("a") then
				if (theWord == 2) then
					scores[guesser] = scores[guesser] + 1
				end
				guesser = guesser + 1

			elseif lk.isDown("s") then
				if (theWord == 3) then
					scores[guesser] = scores[guesser] + 1
				end
				guesser = guesser + 1

			elseif lk.isDown("d") then
				if (theWord == 4) then
					scores[guesser] = scores[guesser] + 1
				end
				guesser = guesser + 1

			end
		end
	end
end

function g2_draw()
	simpleScale.transform()
	if mode == "select" then
		setPlayerColor(artist)
		lg.setFont(font1)
		lg.printf(groups[theGroup][1], 0+math.cos(rot/10)*10, 100-font1:getHeight()/2+math.sin(rot/10)*10, 800, "center")
		lg.setFont(font2)
		lg.printf(groups[theGroup][2], 0+math.cos(rot/11)*10, 250-font2:getHeight()/2+math.sin(rot/11)*10, 400, "center")
		lg.setFont(font3)
		lg.printf(groups[theGroup][3], 400+math.cos(rot/12)*10, 250-font3:getHeight()/2+math.sin(rot/12)*10, 400, "center")
		lg.setFont(font4)
		lg.printf(groups[theGroup][4], 0+math.cos(rot/13)*10, 400-font4:getHeight()/2+math.sin(rot/13)*10, 800, "center")
		unsetPlayerColor()
	elseif mode == "draw" then
		setPlayerColor(artist)
		lg.setFont(canvasFont)
		lg.printf(canvas, 0, 0, 800, "left")
		unsetPlayerColor()
	elseif mode == "vote" then
		setPlayerColor(artist)
		lg.push()
		lg.scale(canvasScale,canvasScale)
		lg.translate((400/canvasScale)-400,0)
		lg.setFont(canvasFont)
		lg.printf(canvas, 0, 0, 800, "left")
		lg.pop()
		votePhrase:draw(500,375+20 +300 - phraseY)

		setPlayerColor(guesser)
		lg.setFont(phraseFont)
		lg.printf(groups[theGroup][1], 100+math.cos(rot/10)*(10/3), 75+20+600-font1:getHeight()/2+math.sin(rot/10)*(10/3)+ -(phraseY), 150, "center")
		lg.printf(groups[theGroup][2], 0+math.cos(rot/11)*(10/3), 75+20+650-font2:getHeight()/2+math.sin(rot/11)*(10/3)+ -(phraseY), 150, "center")
		lg.printf(groups[theGroup][3], 200+math.cos(rot/12)*(10/3), 75+20+650-font3:getHeight()/2+math.sin(rot/12)*(10/3)+ -(phraseY), 150, "center")
		lg.printf(groups[theGroup][4], 100+math.cos(rot/13)*(10/3), 75+20+700-font4:getHeight()/2+math.sin(rot/13)*(10/3)+ -(phraseY), 150, "center")
	end
		unsetPlayerColor()
	simpleScale.letterBox()
end