-- Fix or improve the implementation of the below methods 

function printSmallGuildNames(memberCount)
    -- this method is supposed to print names of all guilds that have less than memberCount max members
    local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"
    local resultId = db.storeQuery(string.format(selectGuildQuery, memberCount))

    -- First check for successful query, to avoid just printing "false"
	if resultId == false then
		return false
	end

    -- Pass the resultID as parameter for the function to work
    local guildName = result.getString(resultId, "name")
	print (guildName)
    -- and free the result after use
	result.free(resultId)
end 