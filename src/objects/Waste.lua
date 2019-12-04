Waste=Class{__includes=Stack}

--undo/redo timer
local urtimer=0


function Waste:init()
	self:resetPosition()
	self.undodata={}
	self.redodata={}
	self.cards={}
end

function Waste:resetPosition()
	self.x,self.y=CARD_WIDTH+2*OFFSET_LEFT+OFFSET_GAP_HOR,OFFSET_TOP	
end

function Waste:rearrange()
	for i=2,#self.cards do self.cards[i].x=self.cards[i-1].x+40-math.min(23,2*math.floor(#self.cards/4)) end	
	if #self.cards>0 then self.x=self.cards[#self.cards].x end
end

function Waste:update(dt)
	urtimer=urtimer+dt
	if urtimer>0.21 then
		self:urdo()
		urtimer=0
	end
end

function Waste:render()
	for _,card in ipairs(self.cards) do
		card:render()
	end
	if self.highlighted then
		drawRect(self.top.x,self.top.y,CARD_WIDTH,CARD_HEIGHT,0.4)
	end
end

--undo/redo mechanism (urdu)
function Waste:urdo()
	if love.keyboard.isDown('lctrl') then
		if love.keyboard.isDown('z') then
			if #self.undodata>0 then

				playURSound()

				self.undodata[#self.undodata]:push(self.top)
				
				if self.undodata[#self.undodata].isPile then
					self.undodata[#self.undodata].y=self.undodata[#self.undodata].y+PILE_OFFSET_TOP
				end

				self.undodata[#self.undodata].top:move(self.undodata[#self.undodata])				
				self:pop()

				table.insert(self.redodata,self.undodata[#self.undodata])
				table.remove(self.undodata)

				--this is why i say programmers need to avoid over-genericisation
				--in the pop function the self's x and y are changed so ... bla bla .. you know (try removing this)
				if #self.undodata==0 then self:resetPosition() end
			end
			
		elseif love.keyboard.isDown('y') then
			if #self.redodata>0 then
				
				playURSound()
				self.redodata[#self.redodata].top:move(self)

				self:push(self.redodata[#self.redodata].top)
				self.top.back=false
				
				self.redodata[#self.redodata]:pop()

				table.insert(self.undodata,self.redodata[#self.redodata])
				table.remove(self.redodata)

				if #self.redodata==0 then self:resetPosition() end
			end
		end
	end
end