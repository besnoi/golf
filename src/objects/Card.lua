Card=Class{}
local locked

function Card:init(suit,value,x,y)
	self.suit=suit
	self.value=value
	self.back=x==nil
	if x==nil and suit>4 then x,y=suit,value end
	self.x,self.y=x or 0,y or 0
end

function Card:render()
	if self.back then
		drawBack(PATTERN_COLOR,PATTERN_VARIANT,self.x,self.y)
	else
		drawCard(self.suit,self.value,self.x,self.y)
	end
end

function Card:move(region)
	if not region then
		self.x,self.y=0,0
	else
		self.x,self.y=region.x,region.y
	end
end	

