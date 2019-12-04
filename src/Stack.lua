Stack=Class{}

--only needed for Pile
function Stack:resetTopPosition() end
function Stack:rearrange() end

function Stack:resetTop()
	if self.top then self:resetTopPosition() end	
	self.top=self.cards[#self.cards]
end

function Stack:push(card)
	self.cards[#self.cards+1]=card
	self:rearrange()
	self:resetTop()
end

function Stack:pushFlip(card)
	card.back=not card.back
	self:push(card)
end

function Stack:pop()
	self.cards[#self.cards]=nil
	self:rearrange()
	self:resetTop()	
end