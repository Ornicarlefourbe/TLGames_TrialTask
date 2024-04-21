local DASH_DISTANCE = 6
local DASH_SECONDSTODESTINATION = 0.3

local ec = EventCallback

-- Do one step of the dash, check if the next tile is walkable.
function doDashStep(playerID, direction)
	local player = Player(playerID)

	local nextPosition = player:getPosition()
	nextPosition:getNextPosition(direction)

	local nextTile = Tile(nextPosition)
	if nextTile:isWalkable() then
		player:teleportTo(nextPosition)
	else
		player:sendCancelMessage("You can't dash any further.")
	end

end


ec.onTurn = function(player, direction, position, category)
	if player:getDirection() == direction then
		-- Schedule every step of the dash to create the animation
		local millisecondsPerDashSteps = DASH_SECONDSTODESTINATION / DASH_DISTANCE * 1000
		for i = 1, DASH_DISTANCE do
			addEvent(doDashStep, millisecondsPerDashSteps * (i - 1), player:getId(), direction)
		end
	else
		player:setDirection(direction)
	end
end

ec:register()
