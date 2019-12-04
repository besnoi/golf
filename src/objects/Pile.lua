Pile=Class{__includes=Stack}


function Pile:init(x,y)
	self.x,self.y=x,y
	self.isPile=true
	self.cards=getRandomCards(5,false,x,y,0,PILE_OFFSET_TOP)
	self:resetTop()
end


function Pile:update(dt)
	dragOnClicking(self,self.top)
end


function Pile:render()
	for _,card in ipairs(self.cards) do
		card:render()
	end
end

function Pile:resetTopPosition()
	self.x,self.y=self.top.x,self.top.y
end
