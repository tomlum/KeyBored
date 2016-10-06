--tomlum w/ indiebrew.me

--Swappable Colors (in order)
--{1,0,0}
--{0,1,0}
--{0,0,1}
--{0,1,1}
--{1,0,1}
--{1,1,0}
--Shades of these colors work also.
--Any image file that has for an rgb value of {0,126,126}
--will get shaded a darker shade of the according swapped color

colorSwap = {}
colorSwap.shader = love.graphics.newShader(
	[[
	extern vec4 swapMap[6];
	vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords){

		vec4 tc = Texel(texture, texture_coords);
		if (tc[3] > 0){
			if (tc[1] == 0 && tc[2] == 0){
				return vec4(
				(swapMap[0][0]/255)*tc[0], 
				(swapMap[0][1]/255)*tc[0], 
				(swapMap[0][2]/255)*tc[0], 
				(swapMap[0][3]/255));
			}
			else if (tc[0] == 1 && tc[1]-tc[2]<.005 && tc[1]-tc[2]>-.005){
				return vec4(
				(swapMap[0][0]/255)+(1-swapMap[0][0])*tc[1], 
				(swapMap[0][1]/255)+(1-swapMap[0][1])*tc[1], 
				(swapMap[0][2]/255)+(1-swapMap[0][2])*tc[1], 
				(swapMap[0][3]/255));
			}

			else if (tc[0] <= 0 && tc[2] <= 0){
				return vec4(
				(swapMap[1][0]/255)*tc[1], 
				(swapMap[1][1]/255)*tc[1], 
				(swapMap[1][2]/255)*tc[1], 
				(swapMap[1][3]/255));
			}
			else if (tc[1] == 1 && tc[0]-tc[2]<.005 && tc[0]-tc[2]>-.005){
				return vec4(
				(swapMap[1][0]/255)+(1-swapMap[1][0])*tc[2], 
				(swapMap[1][1]/255)+(1-swapMap[1][1])*tc[2], 
				(swapMap[1][2]/255)+(1-swapMap[1][2])*tc[2], 
				(swapMap[1][3]/255));
			}

			else if (tc[1] == 0 && tc[0] == 0){
				return vec4(
				(swapMap[2][0]/255)*tc[2], 
				(swapMap[2][1]/255)*tc[2], 
				(swapMap[2][2]/255)*tc[2], 
				(swapMap[2][3]/255));
			}
			else if (tc[2] == 1 && tc[1]-tc[0]<.005  && tc[1]-tc[0]>-.005){
				return vec4(
				(swapMap[2][0]/255)+(1-swapMap[2][0])*tc[1], 
				(swapMap[2][1]/255)+(1-swapMap[2][1])*tc[1], 
				(swapMap[2][2]/255)+(1-swapMap[2][2])*tc[1], 
				(swapMap[2][3]/255));
			}







			else if (tc[0] == 0 && tc[1]-tc[2]<.005 && tc[1]-tc[2]>-.005){
				return vec4(
				(swapMap[3][0]/255)*tc[1], 
				(swapMap[3][1]/255)*tc[1], 
				(swapMap[3][2]/255)*tc[1], 
				(swapMap[3][3]/255));
			}
			else if (tc[1] == 1 && tc[2] == 1){
				return vec4(
				(swapMap[3][0]/255)+(1-swapMap[3][0])*tc[0], 
				(swapMap[3][1]/255)+(1-swapMap[3][1])*tc[0], 
				(swapMap[3][2]/255)+(1-swapMap[3][2])*tc[0], 
				(swapMap[3][3]/255));
			}

			else if (tc[1] == 0 && tc[0]-tc[2]<.005 && tc[0]-tc[2]>-.005){
				return vec4(
				(swapMap[4][0]/255)*tc[0], 
				(swapMap[4][1]/255)*tc[0], 
				(swapMap[4][2]/255)*tc[0], 
				(swapMap[4][3]/255));
			}
			else if (tc[0] == 1 && tc[2] == 1){
				return vec4(
				(swapMap[4][0]/255)+(1-swapMap[4][0])*tc[1], 
				(swapMap[4][1]/255)+(1-swapMap[4][1])*tc[1], 
				(swapMap[4][2]/255)+(1-swapMap[4][2])*tc[1], 
				(swapMap[4][3]/255));
			}


			else if (tc[2] == 0 && tc[0]-tc[1]<.005 && tc[0]-tc[1]>-.005){
				return vec4(
				(swapMap[5][0]/255)*tc[1], 
				(swapMap[5][1]/255)*tc[1], 
				(swapMap[5][2]/255)*tc[1], 
				(swapMap[5][3]/255));
			}
			else if (tc[0] == 1 && tc[1] == 1){
				return vec4(
				(swapMap[5][0]/255)+(1-swapMap[5][0])*tc[2], 
				(swapMap[5][1]/255)+(1-swapMap[5][1])*tc[2], 
				(swapMap[5][2]/255)+(1-swapMap[5][2])*tc[2], 
				(swapMap[5][3]/255));
			}
		}




		return tc;
	}
	]] 
	)

--An Example swapMap
--{{1,.2,.5,1}, {1,0,0,1}}
--Swaps Red with {1,.2,.5,1}
--Swaps Green with {1,0,0,1}
function colorSwap.send(swapMap)
	colorSwap.shader:send("swapMap", 
		swapMap[1] or {255,0,0,255}, 
		swapMap[2] or {0,255,0,255}, 
		swapMap[3] or {0,0,255,255},
		swapMap[4] or {0,255,255,255}, 
		swapMap[5] or {255,0,255,255}, 
		swapMap[6] or {255,255,0,255}
		)
end

--Place before drawing something you want to swap colors for
function colorSwap.set()
	love.graphics.setShader(colorSwap.shader)
end

function colorSwap.unset()
	love.graphics.setShader()
end