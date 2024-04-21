-- Constants
JUMP_UPDATETIME = 75    
JUMP_MOVEPIXELSPERTICK = 10
JUMP_PADDING_HORIZONTAL = 5
JUMP_PADDING_VERTICAL = 5

-- Variables
jumpWindow = nil
jumpWindowButton = nil

function init()
  jumpWindow = g_ui.displayUI('jumpWindow')
  jumpWindow:hide()

  -- create a ticking event
  jumpWindowJumpButton = jumpWindow:recursiveGetChildById('jumpbutton')
  periodicalEvent(updateButtonPosition, canTick, JUMP_UPDATETIME)

  jumpWindowTopmenuButton = modules.client_topmenu.addLeftGameButton('jumpWindowButton', tr('Jump Window'), '/images/topbuttons/jumpwindow', toggle)
end

-- this function will stop the ticking event once the window is closed, so the effect doesn't play for no reason
function canTick()
  local bShouldUpdate = jumpWindow:isVisible()
  return bShouldUpdate
end

-- This is the main ticking function
function updateButtonPosition()
  local newButtonX = jumpWindowJumpButton:getX() - JUMP_MOVEPIXELSPERTICK
  local newButtonY = jumpWindowJumpButton:getY()
  local buttonMinimumX = jumpWindow:getX() + JUMP_PADDING_HORIZONTAL
  
  -- If the button goes too far left, call the resetButtonY function
  if newButtonX < buttonMinimumX then
    resetButtonY()
  else
    jumpWindowJumpButton:setX(newButtonX)
    jumpWindowJumpButton:setY(newButtonY)
  end
end

-- This functions resets the button to the right and gives it a random Y position. It is called when the button is clicked, or reaches the right side of the window.
function  resetButtonY()
  -- Calculate the rightmost possible position for the button, and the possible Y positions for the button.
  local maxPositionX = jumpWindow:getX() + jumpWindow:getWidth() - jumpWindowJumpButton:getWidth() - JUMP_PADDING_HORIZONTAL
  local minPositionY = jumpWindow:getY() +  jumpWindowJumpButton:getHeight() + JUMP_PADDING_VERTICAL
  local maxPositionY = jumpWindow:getY() +  jumpWindow:getHeight() - jumpWindowJumpButton:getHeight() - JUMP_PADDING_VERTICAL

  local newButtonX = maxPositionX
  local newButtonY = math.random(minPositionY, maxPositionY)

  jumpWindowJumpButton:setX(newButtonX)
  jumpWindowJumpButton:setY(newButtonY)
end

function terminate()
  jumpWindow:destroy()
  jumpWindow = nil
  jumpWindowJumpButton = nil
end

function hide()
  jumpWindow:hide()
end

function show()
  jumpWindow:show()
  jumpWindow:raise()
  jumpWindow:focus()
  periodicalEvent(updateButtonPosition, canTick, JUMP_UPDATETIME)
end

function toggle()
  if jumpWindow:isVisible() then
    hide()
  else
    show()
  end
end

function onJumpClicked()
  resetButtonY()
end