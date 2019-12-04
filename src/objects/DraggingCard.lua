DraggingCard=Class{__includes=Card}
local locked

function DraggingCard:update(dt)
	if love.mouse.isDown(1) then
		self:highlightWaste()
	else
		self:lockToWaste()
		if not locked then
			self:moveBack()
			self.parent:push(self:toCard())
		else
			table.insert(gameBoard.waste.undodata,self.parent)
		end
	end
	dragCard(self)
	locked=false
end

--convert DC to non-DC
function DraggingCard:toCard()
	return Card(self.suit,self.value,self.x,self.y)
end

--convert non-DC to DC
function DraggingCard:init(card)
	self.suit=card.suit
	self.value=card.value
	self:move(card)
end

function DraggingCard:moveBack()
	self:move(self.parent)
end


function DraggingCard:highlightWaste()
	gameBoard.waste.highlighted=self.parent~=gameBoard.waste and cardInRegion(self,gameBoard.waste) and  checkLockWaste(self,gameBoard.waste)
end

function DraggingCard:lockToWaste()
	if checkLockWaste(self,gameBoard.waste) then
		locked=lockToRegion(self,gameBoard.waste)
		if locked then
			playCardPlaceSound()
			gameBoard.waste:push(self:toCard())
		end
	end
	gameBoard.waste.highlighted=false
end
--
--
