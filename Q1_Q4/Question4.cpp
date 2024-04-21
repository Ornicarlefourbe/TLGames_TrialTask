// Assume all method calls work fine. Fix the memory leak issue in below method 

// I took an approach similar to Mailbox::sendItem where if the player is not found in g_game, we don't need to use a pointer to player then, and can keep everything on the stack
void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
    // I put this block at the beginning to avoid repeating it in both the if and the else statements that will follow
    Item* item = Item::CreateItem(itemId);
    if (!item) {
        return;
    }

    Player* player = g_game.getPlayerByName(recipient);
    if (player)
    {
        g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);
    }
    else
    {
		Player tmpPlayer(nullptr);
		if (!IOLoginData::loadPlayerByName(&tmpPlayer, receiver))
        {
            // free item here since noone else took ownership of it
            delete item;
			return;
		}
        g_game.internalAddItem(tmpPlayer.getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);
        if (player->isOffline())
        {
            IOLoginData::savePlayer(&tmpPlayer);
        }
    }
} 