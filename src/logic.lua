--some important functions related to cards

function initCards()
	local cards={}
	for i=1,4 do
		cards[i]={}
		for j=1,13 do
			cards[i][j]=Card(i,j)
		end
	end
	return cards
end

function getRandomCard()
	local s=math.random(#gCards)
    local v=math.random(#gCards[s])
	local card=gCards[s][v]
	table.remove(gCards[s],v)
	if #gCards[s]==0 then
		table.remove(gCards,s)
	end
    return card
end

function getRandomCards(n,back,x,y,stepox,stepoy)
	--get n no of random cards with fixed x and y
	local cards={}
	for i=1,n do
		cards[i]=getRandomCard()
		cards[i].x=x
		x=x+(stepox and stepox or 0)				
		cards[i].y=y
		y=y+(stepoy and stepoy or 0)		
		cards[i].back=back
	end
	return cards
end
function getCardValue(value)
	if value==13 then return "Ace"
	elseif value==1 then return "King"
	elseif value==2 then return "Queen"
	elseif value==3 then return "Jack"
	else return 14-value
	end
end

function getCardSuit(suit)
	if suit==1 then return "Hearts"
	elseif suit==2 then return "Spades"
	elseif suit==3 then return "Diamonds"
	else return "Clubs"
	end
end

function getCardInfo(card)
	return getCardValue(card.value).." of "..getCardSuit(card.suit)
end

function aabbcollision(src,src_width,src_height,targetx,targety,target_width,target_height)
	if src.x+src_width<targetx or src.x>targetx+target_width or src.y+src_height<targety or src.y>targety+target_height then
		return false
	end
	return true
end

function dragCard(card)
	--this function is simply for dragging card
	if not card then return end
	card.x,card.y=love.mouse.getPosition()
	card.x=card.x-CARD_WIDTH/2
	card.y=card.y-CARD_HEIGHT/2
end

function regionClicked(x,y)
	--only if you are not dragging a card and you are clicking LMB and you are hovering the region will I say that you are clicking at the region
	return cardIsHovered(x,y) and love.mouse.isDown(1) and not gDragCard
end

function dragOnClicking(region,x,y)
	if region.top and regionClicked(x or region,y) and not region.top.back  then
		gDragCard=DraggingCard(region.top)
		region:pop()
		gDragCard.parent=region
	end
end

function cardIsHovered(x,y)
	if y==nil then x,y=x.x,x.y end
	if love.mouse.x>x and love.mouse.x<x+CARD_WIDTH then
		if love.mouse.y>y and love.mouse.y<y+CARD_HEIGHT then
			return true
		end
	end
	return false
end

function cardInRegion(card,region)
	return aabbcollision(card,CARD_WIDTH,CARD_HEIGHT,region.x,region.y,CARD_WIDTH,CARD_HEIGHT)
end

function lockToRegion(card,region)
	--if a card is in a "hot" region then lock it	
	if cardInRegion(card,region) then
		card:move(region)
		return true
	else
		return false
	end
end

function checkLockWaste(card,waste)
	--check if you can add card to waste
	return waste.top and (waste.top.value==(card.value+1>13 and 1 or card.value+1) or waste.top.value==(card.value-1<1 and 13 or card.value-1))
	--If waste is empty there's no way - only if it's value is adjacent to card's value (note it's a variation of golf)
end

function gameOver(background)
	local score=35
	for i=1,#gameBoard.pile do
		for j=1,#gameBoard.pile[i].cards do
			score=score-1
		end
	end
	gStateMachine:switch('prompt',{
		background=background,
		msg=("Your Score: %d!\n\nDo you want to restart?"):format(score),
		width=400,height=150,
		onYesClick=function() gStateMachine:switch('play') end,
		onNoClick=function() gStateMachine:switch('main-menu') end
	})
end

function isGameOver()
	if #gameBoard.deck.cards>0 then return false end
	for i=1,7 do
		if gameBoard.pile.top and checkLockWaste(gameBoard.pile.top,gameBoard.waste) then
			return false
		end
	end
	return true
end
gMoves={}
notg=0

function getHint()
	for _,pile in ipairs(gameBoard.pile) do
		if checkLockWaste(pile.top,gameBoard.waste) then
			return("Move the "..getCardInfo(pile.top).." onto the "..getCardInfo(gameBoard.waste.top))
		end
	end
	return "Deal another Card"
end

recursionspace=""

function makeDecision(waste,deck,piles,move)
	local pile_found=false
	for i,pile in ipairs(piles) do
		if #pile.cards>0 and waste.cards[#waste.cards] and ((waste.cards[#waste.cards].value==(pile.cards[#pile.cards].value+1>13 and 1 or pile.cards[#pile.cards].value+1)) or (waste.cards[#waste.cards].value==(pile.cards[#pile.cards].value-1<1 and 13 or pile.cards[#pile.cards].value-1)))  then
			pile_found=true
			-- print("Move "..getCardInfo(pile.cards[#pile.cards]).." to waste")			
			table.insert(move,{toX=pile.cards[#pile.cards].x+CARD_WIDTH/2,toY=pile.cards[#pile.cards].y+CARD_HEIGHT/2,clickOnDest=2})
			-- table.insert(move,{toX=waste.cards[#waste.cards].x+CARD_WIDTH/2,toY=waste.cards[#waste.cards].y+CARD_HEIGHT/2,clickOnDest=2})
			table.insert(waste.cards,pile.cards[#pile.cards])
			table.remove(pile.cards)
			makeDecision(waste,deck,piles,move)
			break
		end
	end
	if #deck.cards>0 and not pile_found then
		-- print("Redeal "..getCardInfo(deck.cards[#deck.cards]))
		table.insert(move,{toX=deck.cards[#deck.cards].x+CARD_WIDTH/2,toY=deck.cards[#deck.cards].y+CARD_HEIGHT/2,clickOnDest=1})
		table.insert(waste.cards,deck.cards[#deck.cards])
		table.remove(deck.cards)
		makeDecision(waste,deck,piles,move)		
	end
end

--Smart decision- looks at all the combinations [NEEDS MEMOIZATION AND OTHER CHANGES]
--every combination will be added to move table and 
--if a combination leads to score >30 then it will add that combination to Best_moves table
--later the best combination will be selected from Best_moves table and would AI_MOVES
function makeSmartDecision(waste,deck,piles,move)
	local pile_found=false
	for i,pile in ipairs(piles) do
		if #pile.cards<=0 then print("PILE CARDS IS EQUAL TO ZERO") goto continue end
		if waste.cards[#waste.cards] and ((waste.cards[#waste.cards].value==(pile.cards[#pile.cards].value+1>13 and 1 or pile.cards[#pile.cards].value+1)) or (waste.cards[#waste.cards].value==(pile.cards[#pile.cards].value-1<1 and 13 or pile.cards[#pile.cards].value-1)))  then
			pile_found=true
			print(recursionspace.."Move "..getCardInfo(pile.cards[#pile.cards]).." to waste")
			table.insert(waste.cards,pile.cards[#pile.cards])
			table.remove(pile.cards)
			recursionspace=recursionspace.." "
			makeSmartDecision(waste,deck,piles,move)
			recursionspace=recursionspace:sub(1,recursionspace:len()-1)
			table.insert(pile.cards,waste.cards[#waste.cards])
			table.remove(waste.cards)
			print(recursionspace.."BACKTRACKING MOVE:  "..getCardInfo(pile.cards[#pile.cards]))				
		end
		::continue::
	end
	
	print(recursionspace.."PILE_FOUND: "..tostring(pile_found))

	if #deck.cards<=0 then return end
	
	if #deck.cards>0 and not pile_found then
		print(recursionspace.."Redeal "..getCardInfo(deck.cards[#deck.cards]))
		table.insert(waste.cards,deck.cards[#deck.cards])
		table.remove(deck.cards)
		makeSmartDecision(waste,deck,piles,move)
		table.insert(deck.cards,waste.cards[#waste.cards])
		table.remove(waste.cards)
		print(recursionspace.."BACKTRACKING REDEAL:  "..getCardInfo(deck.cards[#deck.cards]))
	end
end