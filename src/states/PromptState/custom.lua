
function popupMsg()
    love.graphics.setColor(colors:getColor('lightgrey',0.9))
    love.graphics.rectangle('fill',
        WWIDTH/2-150,WWIDTH/2-50,300,100
    )
    love.graphics.setFont(gFonts.msgFont)
    
    love.graphics.setColor(0.44,0.5,0.56,1)  --slategrey
    love.graphics.rectangle('line',WWIDTH/2-151,WWIDTH/2-51,300,100)
    
    if self.ov then
        love.graphics.setColor(colors.darkslategrey)
    end

    love.graphics.circle('fill',WWIDTH/2+148,WWIDTH/2-48,10,6)
    
    checkPopupHover(WWIDTH/2-130,WWIDTH/2+13,65,30,1)
    checkPopupHover(WWIDTH/2+55,WWIDTH/2+13,65,30,2)
    
    
    if circle_hover==true then
        love.graphics.setColor(colors.white)
        if love.mouse.isDown(1) then
            popup=false
        end
    end
    love.graphics.circle('fill',WWIDTH/2+148,WWIDTH/2-48,3,10)        
    love.graphics.setColor(1,1,1)
end

