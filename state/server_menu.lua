server_menu = {}

local buttons = {}
local fields = {}
local labels = {}

function server_menu:init()
  server = nil
  mousePos = HC.point(love.mouse.getX(), love.mouse.getY())
  buttons.startServer = Button(1/2, 1/6, 1/8, 1/14, "Start Server")
  buttons.startServer.action = toggleServer
  fields.ip = FillableField(1/2, 1/10, 1/8, 1/30, ipAddress, false)
end

function server_menu:update(dt)
  self:handleMouse(dt)
  
  for i, button in pairs(buttons) do
    button:update(dt)
  end
  
  for i, field in pairs(fields) do
    field:update(dt)
  end
  
  if server ~= nil then
    server:update(dt)
  end
end

function server_menu:draw()
  drawFPS(fpsCounter)
  
  for i, button in pairs(buttons) do
    button:draw()
  end
  
  for i, field in pairs(fields) do
    field:draw()
  end
  
  if server ~= nil then
    server:draw()
  end
end

function server_menu:textinput(key)
  
  for i, field in pairs(fields) do
    field:textinput(key)
  end
end


function server_menu:keypressed(key)
  for i, field in pairs(fields) do
    field:keypressed(key)
  end
  
  if key == "escape" then
    if server then
      server.sender:destroy()
      server = nil
    end
    love.event.quit()
  end
  
end

function server_menu:mousepressed(mousex,mousey,mouseButton,isTouch)
  mousePos = HC.point(mousex, mousey)
  
  if mouseButton == 1 then
    for pos, field in pairs(fields) do
      field:highlight(mousePos)
      field:mousepressed(mouseButton)
    end
    
    for pos, button in pairs(buttons) do
      button:highlight(mousePos)
      button:mousepressed(mouseButton)
    end
  end
end

function server_menu:handleMouse(dt)
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

function toggleServer()
  if server == nil then
    server = ServerObject(fields.ip:getvalue(), 1992, server_data)
    fields.ip.isSelectable = false
    buttons.startServer.text = "Stop Server"
  else
    server.sender:destroy()
    server = nil
    fields.ip.isSelectable = true
    buttons.startServer.text = "Start Server"
  end
end