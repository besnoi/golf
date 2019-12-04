math.randomseed(os.time())
-- push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT,WINDOW_WIDTH, WINDOW_HEIGHT)
love.window.setMode(VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
-- push:setBorderColor(lovecc.getHex("008800"))
love.window.setTitle("Golf Solitaire")
fcursor.setSpeed(5,5)
fcursor.setStageTime(1)


function generateCardFrontQuads()
	local quads={}
	for i=1,4 do 
		quads[i]={}
		for j=1,13 do
			quads[i][j]=love.graphics.newQuad(700+(j-1)*CARD_WIDTH,(i-1)*CARD_HEIGHT,CARD_WIDTH,CARD_HEIGHT,gImg:getDimensions())
		end
	end
	return quads
end

function generateCardBackQuads()
	local quads={}
	for i=1,4 do 
		quads[i]={}
		for j=1,5 do
			quads[i][j]=love.graphics.newQuad((j-1)*CARD_WIDTH,(i-1)*CARD_HEIGHT,CARD_WIDTH,CARD_HEIGHT,gImg:getDimensions())
		end
	end
	return quads
end

--init gSprCards and prPatterns
gSprCards=generateCardFrontQuads()
gSprPatterns=generateCardBackQuads()