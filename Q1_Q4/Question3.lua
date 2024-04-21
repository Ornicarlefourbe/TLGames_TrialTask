-- Fix or improve the name and the implementation of the below method 

-- this function removes player membername from playerId's party
function removeMemberFromParty(playerId, membername)
    local player = Player(playerId)

    -- check if the target player was found
    if player == nil then
        return false
    end

    local party = player:getParty()

    -- check if there is a party
    if party == nil then
        return false
    end
    
    for k,v in pairs(party:getMembers()) do
        if v == Player(membername) then
        party:removeMember(Player(membername))
        end
    end
end 