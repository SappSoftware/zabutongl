client_menu = {}

local buttons = {}
local fields = {}

function client_menu:init()
  
end

function client_menu:update(dt)
  mousePointer:moveTo(love.mouse.getX(), love.mouse.getY())
  
  local highlightButton = false
  local highlightField = false
  
  
  
  
  if highlightButton then
    love.mouse.setCursor(cur_highlight)
  elseif highlightField then
    love.mouse.setCursor(cur_field)
  else
    love.mouse.setCursor()
  end
  
  client:update(dt)
end

function client_menu:draw()
  if client ~= nil then
    client:draw()
    client:drawPlayerList(600, 300)
    client:drawLobbyList(150, 300)
  end
  
  for i, button in pairs(buttons) do
    button:draw()
  end
  
  for i, field in pairs(fields) do
    field:draw()
  end
end

function client_menu:keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function client_menu:mousepressed(x,y,button)
  
end

function client_menu:quit()
  if client ~= nil then
    client.sender:disconnectNow()
  end
end
