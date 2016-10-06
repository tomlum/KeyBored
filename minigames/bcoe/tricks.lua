--Insert the score to rpint into a table, slowly move it up and dissolve it
--map sound to score 
lg.setDefaultFilter("linear","nearest",1)

tricks = {
	{im = g1NewImage("tricks/monalisa.png"), name = "MONALISA"},
	{im = g1NewImage("tricks/cerberus.png"), name = "CERBERUS"},
	{im = g1NewImage("tricks/headless.png"), name = "HEADLESS"},
	{im = g1NewImage("tricks/shortman.png"), name = "SHORT"},
	{im = g1NewImage("tricks/tallman.png"), name = "TALL"},
	{im = g1NewImage("tricks/splits.png"), name = "SPLITS"},
	{im = g1NewImage("tricks/topsyturvy.png"), name = "TOPSY-TURVY"},
	{im = g1NewImage("tricks/tpose.png"), name = "TPOSE"},
	{im = g1NewImage("tricks/oppositeday.png"), name = "OPPOSITE DAY"},
	{im = g1NewImage("tricks/satan.png"), name = "HAIL SATAN 666"},
	{im = g1NewImage("tricks/ralphellison.png"), name = "Ralph Ellison"},
	{im = g1NewImage("tricks/dealwithit.png"), name = "DEAL WITH IT"},
	{im = g1NewImage("tricks/wifeswap.png"), name = "WIFE SWAP"},
	{im = g1NewImage("tricks/finedining.png"), name = "FINE DINING"},
	{im = g1NewImage("tricks/tiny.png"), name = "TINY"},
	{im = g1NewImage("tricks/hangten.png"), name = "HANG TEN"},
	{im = g1NewImage("tricks/ollie.png"), name = "ollie"},
	{im = g1NewImage("tricks/boardtastic.png"), name = "BOARDTASTIC"},
	{im = g1NewImage("tricks/hizard.png"), name = "YOU'RE A HIZARD WARRY"},
	{im = g1NewImage("tricks/ollie.png"), name = "ollie"},
	{im = g1NewImage("tricks/ollie.png"), name = "ollie"},
	{im = g1NewImage("tricks/ollie.png"), name = "ollie"},
	{im = g1NewImage("tricks/ollie.png"), name = "ollie"},
	{im = g1NewImage("tricks/ollie.png"), name = "ollie"},
	{im = g1NewImage("tricks/ollie.png"), name = "ollie"},
	{im = g1NewImage("tricks/ollie.png"), name = "ollie"},
	{im = g1NewImage("tricks/ollie.png"), name = "ollie"}
}

trickSounds = {
	wombo = g1NewSource("sounds/wombo.mp3"),
	nuke = g1NewSource("sounds/nuke.mp3"),
	mlg = g1NewSource("sounds/mlg.mp3"),
	leeroy = g1NewSource("sounds/leeroy.mp3"),
	saber = g1NewSource("sounds/saber.wav"),
	ring = g1NewSource("sounds/ring.wav"),
	zeldasecret = g1NewSource("sounds/zeldasecret.mp3"),
	metalgearalert = g1NewSource("sounds/metalgearalert.mp3"),
	hit = g1NewSource("sounds/hit.mp3"),
	loudnoises = g1NewSource("sounds/loudnoises.mp3"),
	gasp = g1NewSource("sounds/gasp.mp3"),
	wilhelm = g1NewSource("sounds/wilhelm.mp3"),
	scream = g1NewSource("sounds/scream.ogg"),
	cheer = g1NewSource("sounds/cheer.wav"),
	yay = g1NewSource("sounds/yay.mp3"),
	yeah = g1NewSource("sounds/yeah.wav"),
	ooh = g1NewSource("sounds/ooh.wav"),
	blade = g1NewSource("sounds/blade.ogg"),
	swoosh = g1NewSource("sounds/swoosh.mp3"),
	punch = g1NewSource("sounds/punch.mp3"),
	sword = g1NewSource("sounds/sword.mp3"),
	whoosh = g1NewSource("sounds/whoosh.wav"),
	snare = g1NewSource("sounds/snare.wav"),
	bell = g1NewSource("sounds/bell.wav"),
	clatter = g1NewSource("sounds/clatter.wav"),
	aah = g1NewSource("sounds/aah.wav"),
	rim = g1NewSource("sounds/rim.wav"),
	explosion = g1NewSource("sounds/explosion.mp3"),
	song = g1NewSource("sounds/fire.mp3"),
	jumpsound = g1NewSource("sounds/jump.mp3")
}

trickscores = {
	{points = 260, sound = trickSounds.wombo},
	{points = 240, sound = trickSounds.nuke},
	{points = 220, sound = trickSounds.mlg},
	{points = 200, sound = trickSounds.leeroy},
	{points = 180, sound = trickSounds.saber},
	{points = 160, sound = trickSounds.ring},
	{points = 140, sound = trickSounds.zeldasecret},
	{points = 120, sound = trickSounds.metalgearalert},
	{points = 100, sound = trickSounds.hit},
	{points = 95, sound = trickSounds.loudnoises},
	{points = 90, sound = trickSounds.gasp},
	{points = 85, sound = trickSounds.wilhelm},
	{points = 80, sound = trickSounds.scream},
	{points = 75, sound = trickSounds.cheer},
	{points = 70, sound = trickSounds.yay},
	{points = 65, sound = trickSounds.yeah},
	{points = 60, sound = trickSounds.ooh},
	{points = 55, sound = trickSounds.blade},
	{points = 50, sound = trickSounds.swoosh},
	{points = 45, sound = trickSounds.punch},
	{points = 40, sound = trickSounds.sword},
	{points = 35, sound = trickSounds.whoosh},
	{points = 30, sound = trickSounds.snare},
	{points = 25, sound = trickSounds.bell},
	{points = 20, sound = trickSounds.clatter},
	{points = 15, sound = trickSounds.aah},
	{points = 10, sound = trickSounds.rim},
}

scoreboard = {}

function g1_doTrick()
	if trickKey == "q" then
		trick = tricks[1]
	elseif trickKey == "w" then
		trick = tricks[2]
	elseif trickKey == "e" then
		trick = tricks[3]
	elseif trickKey == "r" then
		trick = tricks[4]
	elseif trickKey == "t" then
		trick = tricks[5]
	elseif trickKey == "y" then
		trick = tricks[6]
	elseif trickKey == "u" then
		trick = tricks[7]
	elseif trickKey == "i" then
		trick = tricks[8]
	elseif trickKey == "o" then
		trick = tricks[9]
	elseif trickKey == "p" then
		trick = tricks[10]
	elseif trickKey == "a" then
		trick = tricks[11]
	elseif trickKey == "s" then
		trick = tricks[12]
	elseif trickKey == "d" then
		trick = tricks[13]
	elseif trickKey == "f" then
		trick = tricks[14]
	elseif trickKey == "g" then
		trick = tricks[15]
	elseif trickKey == "h" then
		trick = tricks[16]
	elseif trickKey == "j" then
		trick = tricks[17]
	elseif trickKey == "k" then
		trick = tricks[18]
	elseif trickKey == "l" then
		trick = tricks[19]
	elseif trickKey == "z" then
		trick = tricks[2]
	elseif trickKey == "x" then
		trick = tricks[3]
	elseif trickKey == "c" then
		trick = tricks[4]
	elseif trickKey == "v" then
		trick = tricks[5]
	elseif trickKey == "b" then
		trick = tricks[6]
	elseif trickKey == "n" then
		trick = tricks[7]
	elseif trickKey == "m" then
		trick = {im = g1NewImage("tricks/splits.png"), sound = rim, color = {255,255,255}, points = 10, name = "SPLIT"}
	end

	if trickKey ~= oldTrickKey and trick~=nil then
		skater.im = trick.im
		cu.repplay(trick.sound)
		currentScore = currentScore + trick.points
		table.insert(scoreboard, {name = trick.name.."!!!!!", 
			time = 0, 
			color = g1_randomColor(), 
			points = trick.points,
			x = math.random(100),
			y = math.random(50)})
	end

	oldTrickKey = trickKey
end

function g1_randomColor()
	return {math.random(255),math.random(255),math.random(255)}
end

function g1_drawScoreBoard()
	for i,trick in ipairs(scoreboard) do
		if trick.time > 200 then
			table.remove(scoreboard, i) 
		else
			trick.time = trick.time + 2
			lg.setColor(trick.color[1],trick.color[2],trick.color[3])
			lg.setFont(trickfont)
			lg.printf(trick.name, trick.x, 10+trick.y, 40-trick.time/30, "center")
			lg.printf(trick.points, -20+math.random()/2, 50-trick.time, 60-trick.time/10, "center")

		end
	end
end

function g1_shuffleTricks()
	for n,trick in ipairs(tricks) do
		trick.points = trickscores[n].points
		trick.sound = trickscores[n].sound
	end
	g1_shuffleTable(tricks)
end

function g1_shuffleTable( t )
	local j

	for i = #t, 2, -1 do
		j = math.random(i)
		t[i], t[j] = t[j], t[i]
	end
end
