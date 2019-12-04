PlayState=State()

function PlayState:enter()
	--this cards is going to be global but its shortlived (only use is in init functions) and not constant
	gCards=initCards()
	gameBoard=GameBoard()
end

function PlayState:update(dt)
	gameBoard:update(dt)
end

function PlayState:render()
	gameBoard:render()
end