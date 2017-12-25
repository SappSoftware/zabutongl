server_menu = {}

local fields = {}

server = nil

function server_menu:init()
  mousePointer = HC.point(love.mouse.getX(), love.mouse.getY())
  but_startServer = Button(math.floor(SWIDTH/2), math.floor(SHEIGHT/6), SWIDTH/8, SHEIGHT/14, "Start Server")
  fields.ip = FillableField(math.floor(SWIDTH/2), math.floor(SHEIGHT/10), SWIDTH/8, SHEIGHT/30, ipAddress, false)
end

function server_menu:update(dt)
  local highlightButton = false
  local highlightField = false
  mousePointer:moveTo(love.mouse.getX(), love.mouse.getY())
  
  if but_startServer:highlight(mousePointer) then
    highlightButton = true
  end
  
  for i, field in pairs(fields) do
    field:update(dt)
    if field:highlight(mousePointer) then
      highlightField = true
    end
  end
  
  if highlightButton then
    love.mouse.setCursor(cur_highlight)
  elseif highlightField then
    love.mouse.setCursor(cur_field)
  else
    love.mouse.setCursor()
  end
  
  if server ~= nil then
    server:update(dt)
  end
end

function server_menu:draw()
  love.graphics.setColor(WHITE)
  
  but_startServer:draw()
  
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
  if server == nil then
    for i, field in pairs(fields) do
      field:keypressed(key)
    end
  end
  
  if key == "escape" then
    if server then
      server.sender:destroy()
      server = nil
    end
    love.event.quit()
  end
  
end

function server_menu:mousepressed(x,y,button,isTouch)
  if button == 1 then
    if but_startServer:highlight(mousePointer) then
      if server == nil then
        server = ServerObject(fields.ip:getvalue(), 1992, server_data)
        but_startServer.text = "Stop Server"
      else
        server.sender:destroy()
        server = nil
        but_startServer.text = "Start Server"
      end
    end
    for i, field in pairs(fields) do
      field:mousepressed(button)
    end
  end
end
