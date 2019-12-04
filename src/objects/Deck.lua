Deck=Class{__includes=Stack}

--we are setting a deckTimer because we don't want user to sort of click infinitely and lose all
--the redeal so effectively we will respond to clicks only once in every 0.2 seconds

local deckTimer=0

function Deck:init()
	self.x,self.y=OFFSET_LEFT,OFFSET_TOP
	self.cards=getRandomCards(52-35,true,OFFSET_LEFT,OFFSET_TOP)
	self:resetTop()
	self.redeal=2
end

function Deck:update(dt)
	deckTimer=deckTimer+dt	
	if deckTimer>0.2 and (regionClicked(self) or self.aiClicked)  then
		self.aiClicked=nil
		deckTimer=0
		if self.top then
			playCardSlideSound()
			self.top:move(gameBoard.waste)
			gameBoard.waste:pushFlip(self.top)
			table.insert(gameBoard.waste.undodata,self)
			self:pop()
		else
			gameOver(gameBoard)
		end
	end
end

function Deck:render()
	for _,card in ipairs(self.cards) do
		card:render()
	end
end

function Deck:reStock()
	for i=#gameBoard.stock.cards,1,-1 do
		gameBoard.stock.cards[i]:move(self)
		self:pushFlip(gameBoard.stock.cards[i])
		gameBoard.waste:pop()
	end
end

--who said we only reset the top position in the function [THIS IS USEFUL FOR UNDO OPERATION]
function Deck:resetTopPosition()
	if not self.cards[#self.cards] then return end
	self.cards[#self.cards].back=true
end