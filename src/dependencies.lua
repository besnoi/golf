--require the libraries
Class=require 'lib.class'
fcursor=require 'lib.autocursor'
lovecc=require 'lib.lovecc'
require 'lib.itable'

--require the global stuff (all magic nos go here)
require 'src.constants'

--require the resources
require 'src.resources'

--require the quads generation mechanism and init CARDS,PATTERN
require 'src.util'


--require the special drawing functions
require 'src.custom'

--require the special logic functions to abstract things as much as possible
require 'src.logic'

--the Stack prototype
require 'src.Stack'


--require the object prototypes
require 'src.objects.Card'
require 'src.objects.DraggingCard'

gMusic=love.audio.newSource('assets/audio/music.mp3','stream')
gMusic:setLooping(true)
gMusic:play()
require 'src.objects.Waste'
require 'src.objects.Deck'
require 'src.objects.Pile'
require 'src.objects.GameBoard'


require 'src.StateMachine'
require 'src.State'
require 'src.states.PlayState'
require 'src.states.MainMenuState'
require 'src.states.PromptState.main'
require 'src.states.PromptState.util'
require 'src.states.PromptState.custom'

gStateMachine=StateMachine{
	['main-menu']=function() return MainMenuState() end,
	['play']=function() return PlayState() end,
	['prompt']=function() return PromptState() end
}:switch('main-menu')
