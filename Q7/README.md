# Question 7

To create this UI, I added a module in the client, called game_jumpwindow.
At startup, the module creates a window and registers itself to the top menu. To open the window, click the pink scroll button on the top menu.
I used a periodicalEvent to create a tick for this UI, that only runs when the window is opened. 