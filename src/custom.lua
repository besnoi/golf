local function drawGreenBackground()
	--6==math.ceil(VIRTUAL_HEIGHT/128) when VIRTUAL_HEIGHT=720
	lovecc.setColor("lime")
	for i=1,6 do 
		love.graphics.draw(gBackground,0,(i-1)*128)
	end
	lovecc.reset()
end

function drawRect(x,y,width,height,op)
	if op then lovecc.setColor("blue",op)
	else lovecc.setColor("white",0.15) end

	love.graphics.rectangle('fill',x,y,width,height,8,8)
	lovecc.reset()	
	love.graphics.rectangle('line',x,y,width,height,8,8)
end

function drawBackground()
	drawGreenBackground()
	drawRect(OFFSET_LEFT,OFFSET_TOP,CARD_WIDTH,CARD_HEIGHT)
	drawRect(OFFSET_LEFT+OFFSET_LEFT+OFFSET_GAP_HOR+CARD_WIDTH,OFFSET_TOP,CARD_WIDTH,CARD_HEIGHT)

	for i=1,7 do
		drawRect(OFFSET_LEFT*i+(i-1)*(CARD_WIDTH+OFFSET_LEFT),OFFSET_GAP_VER+CARD_HEIGHT,CARD_WIDTH,CARD_HEIGHT)
	end
	lovecc.reset()
end

--since we will ALWAYS DRAW only a single sprite with two different quads it makes sense to have 
--two custom draw function to draw either of the quads

function drawCard(suit,value,...)
	love.graphics.draw(gImg,gSprCards[suit][value],...)
end

function drawBack(color,design,...)
	love.graphics.draw(gImg,gSprPatterns[color][design],...)
end
