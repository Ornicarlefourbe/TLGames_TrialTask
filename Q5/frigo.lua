AREA_FRIGOPOTENTIAL = {
	{0, 0, 0, 0, 1, 0, 0, 0, 0},
	{0, 0, 0, 1, 1, 1, 0, 0, 0},
	{0, 0, 1, 1, 1, 1, 1, 0, 0},
	{0, 1, 1, 1, 1, 1, 1, 1, 0},
	{1, 1, 1, 1, 2, 1, 1, 1, 1},
	{0, 1, 1, 1, 1, 1, 1, 1, 0},
	{0, 0, 1, 1, 1, 1, 1, 0, 0},
	{0, 0, 0, 1, 1, 1, 0, 0, 0},
	{0, 0, 0, 0, 1, 0, 0, 0, 0}
}

-- Animation settings
local ANIMATION_PATTERNSPERSECONDS = 4
local ANIMATION_DURATIONSECONDS = 3

local combats = {}

-- Util function to deep copy a table
function copyTable(originalTable)
	if (type(originalTable) ~= 'table') then
		return originalTable
	end

    local copiedTable = {}
    for k, v in pairs(originalTable) do
		copiedTable[k] = copyTable(v)
	end
    return copiedTable
end

-- Create a random pattern by taking ARE_FRIGOPOTENTIAL, and every 1 in this table will have a 50% chance of being a 1 in the resulting table
function generateRandomArea()
	local randomArea = copyTable(AREA_FRIGOPOTENTIAL)

	for k, v in pairs(randomArea) do
		for k2, v2 in pairs (v) do
			if v2 == 1 then
				v[k2] = math.random(0, 1)
			end
		end
	end
	return createCombatArea(randomArea)
end

-- Create the combat objects and generate a different random area for each
local patternNumbers = ANIMATION_DURATIONSECONDS * ANIMATION_PATTERNSPERSECONDS
for i = 1, patternNumbers do
	combats[i] = Combat()
	combats[i]:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
	combats[i]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)
	combats[i]:setArea(generateRandomArea())
end

function executeSingleCombat(combat, playerID, variant)
	local player = Player(playerId)
	combat:execute(player, variant)
end

function onCastSpell(creature, variant)
    -- Damage formula (same as eternal winter)
    local level = creature:getLevel()
    local magicLevel = creature:getMagicLevel()
	local min = (level / 5) + (magicLevel * 5.5) + 25
	local max = (level / 5) + (magicLevel * 11) + 50

	for k, v in pairs(combats) do
        v:setFormula(COMBAT_FORMULA_LEVELMAGIC, 0, -min, 0, -max)

		if k == 1 then
			-- Start the first "frame" immediatly
			v:execute(creature, variant)
		else
			-- Schedule every "frame" of the spell to create the animation.
			local timeBetweenTwoPatterns = 1000 / ANIMATION_PATTERNSPERSECONDS
			local thisPatternDelay = timeBetweenTwoPatterns * (k - 1)
			addEvent(executeSingleCombat, thisPatternDelay, v, creature.uid, variant)
		end
	end

	return true
end


