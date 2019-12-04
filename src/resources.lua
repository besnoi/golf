--resources (we only have two image and two quads)
gImg=love.graphics.newImage("assets/images/spritesheet.png")
gBackground=love.graphics.newImage("assets/images/back.jpg")
--initialised in util
gSprCard,gSprPattern=nil

gSounds={}

for i=1,8 do
	gSounds[i]=love.audio.newSource("assets/audio/cardSlide"..i..".ogg","static")
end

gSounds[9]=love.audio.newSource("assets/audio/buzz.wav","static")

gFonts={
	['large']=love.graphics.newFont("assets/fonts/ostrich-sans-black.ttf",35)
}



function playSound(sfx_id)
	gSounds[sfx_id]:stop()
	gSounds[sfx_id]:play()
end

--when you slide cards from deck to stock
function playCardSlideSound()
	playSound(4)
end

--when you place a dragging card to a new location
function playCardPlaceSound()
	playSound(1)
end

--when no more redeals are left
function playBuzzSound()
	playSound(9)
end

--when you undo or redo a move 
function playURSound()
	playSound(3)
end