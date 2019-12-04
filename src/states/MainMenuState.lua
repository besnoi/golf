MainMenuState=State()

function MainMenuState:enter()
	self.timer=0
	
	self.orbitonFont=love.graphics.newFont("assets/fonts/arial.ttf",20)
	self.arialFont=love.graphics.newFont("assets/fonts/Orbitron Medium.otf",20)
	self.backImage=love.graphics.newImage('assets/images/mainBackground.png')
end

function MainMenuState:update(dt)
	self.timer=self.timer+dt
	if self.timer>1 then self.timer=0 end
end

function MainMenuState:render()
	love.graphics.setColor(1,1,1)
	love.graphics.draw(self.backImage)
	self:renderOtherStuff()
end

function MainMenuState:mousePressed(_,_,btn)
	if btn==1 then gStateMachine:switch('play') end
end

function MainMenuState:renderOtherStuff()
	love.graphics.rectangle("line",40,330,482,242)
	love.graphics.rectangle('line',40, 280, 482,50)
	love.graphics.setFont(self.arialFont)
	if self.timer>.3 and self.timer<1 then
		love.graphics.printf("Click to start the game ",0,680,1280,'center');
	end
	love.graphics.printf("Game Objectives:",42,293,482,'center');
	love.graphics.setFont(self.orbitonFont)
	love.graphics.printf("The main goal of the game is to move all the cards to the waste which can be build up from the available cards on the Tableau. Only Deuces can be placed on Aces and nothing can be played on to a King. Cards are dealt singly from Stock to Waste. There are no redeals. Every card moved from Tableau to Waste scores one point. Try your best to score 35 or somewhat around that! By the way, you can undo/redo by Ctrl-Z/Ctrl-Y. Press H for hint and A when confused!",42,340,478,'justify')
	love.graphics.setColor(0.7,0.7,0.7)    
	love.graphics.print("(C) Copyright Okra Softmakers",12,690)
end

function MainMenuState:exit()
	self.backImage:release()
	self.orbitonFont:release()
	self.arialFont:release()
end