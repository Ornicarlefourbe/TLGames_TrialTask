-- Fix or improve the implementation of the below methods 

-- Passing a player reference in a delayed event is unsafe, so instead we take the ID as an argument instead
local function releaseStorage(playerID)
	local player = Player(playerID)

    -- Check if player was found
    if player == nil do
        return false
    end

    player:setStorageValue(1000, -1)
end
    
function onLogout(player)
    if player:getStorageValue(1000) == 1 then
        -- Here pass the ID instead of the reference to the player
        addEvent(releaseStorage, 1000, player:getId())
    end
    return true
end
    