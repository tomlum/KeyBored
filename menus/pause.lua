pause = false
quitTimer = 0
selectTimer = 0
im_pause = lg.newImage("assets/im/pause.png")
im_pause2 = lg.newImage("assets/im/pause2.png")

function drawPause()
	lg.setColor(255,255,255)
	if pause then
		if MODE == "PLAY" then
			lg.draw(im_pause2,0,0,0,5,5)
		else
			lg.draw(im_pause,0,0,0,5,5)
		end
	end
end

function updatePause()
	if pause then
		if lk.isClick("escape") then
			pause = false
		elseif lk.isDown("return") then
			quitTimer = quitTimer + 1
			if quitTimer > 50 then
				love.event.quit()
			end
		elseif lk.isDown("delete") and MODE == "PLAY" then
			selectTimer = selectTimer + 1
			if selectTimer > 50 then
				MODE = "SELECT"
			end
		else
			quitTimer = 0
			selectTimer = 0
		end
	else
		if lk.isClick("escape") then
			pause = true
		end
	end
end