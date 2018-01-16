client_menu = {}

local buttons = {}
local fields = {}
local labels = {}

function client_menu:init()
  
end

function client_menu:update(dt)
  self:handleMouse(dt)
  
  client:update(dt)
end

function client_menu:draw()
  drawFPS(fpsCounter)
  if client ~= nil then
    client:draw()
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

function client_menu:handleMouse(dt)
  mousePos:moveTo(love.mouse.getX(), love.mouse.getY())
  local highlightButton = false
  local highlightField = false
  
  for key, button in pairs(buttons) do
    button:update(dt)
    if button:highlight(mousePos) then
      highlightButton = true
    end
  end
  
  for key, field in pairs(fields) do
    field:update(dt)
    if field:highlight(mousePos) then
      highlightField = true
    end
  end
  
  if highlightButton then
    love.mouse.setCursor(CUR.H)
  elseif highlightField then
    love.mouse.setCursor(CUR.I)
  else
    love.mouse.setCursor()
  end
end
