function PromptState:check_mouse_hover(x,y,width,height)
	return love.mouse.getX()>=x and love.mouse.getX()<=x+width and
		   love.mouse.getY()>=y and love.mouse.getY()<=y+height
end

function PromptState:check_button_hover()
	self.no_hovered=self:check_mouse_hover(self.x+self.width-90,self.y+self.height-40,65,30)
	self.yes_hovered=self:check_mouse_hover(self.x+50,self.y+self.height-40,65,30)
	if love.mouse.isDown(1) then
		if self.yes_hovered then
			self.onYesClick()
		end
		if self.no_hovered then
			self.onNoClick()
		end
	end
end

function PromptState:check_closebtn_hover()
	self.closebtn_hovered=self:check_mouse_hover(self.x+self.width-5,self.y-10,15,15)
	if love.mouse.isDown(1) and self.closebtn_hovered then
		self.onClose()
	end
end