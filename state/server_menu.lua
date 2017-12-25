server_menu = {}

local buttons = {}
local fields = {}
local labels = {}

server = nil

function server_menu:init()
  mousePointer = HC.point(love.mouse.getX(), love.mouse.getY())
  buttons.startServer = Button(math.floor(SW/2), math.floor(SH/6), SW/8, SH/14, "Start Server")
  fields.ip = FillableField(math.floor(SW/2), math.floor(SH/10), SW/8, SH/30, ipAddress, false)
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
    love.mouse.setCursor(CUR.H)
  elseif highlightField then
    love.mouse.setCursor(CUR.I)
  else
    love.mouse.setCursor()
  end
  
  if server ~= nil then
    server:update(dt)
  end
end

function server_menu:draw()
  love.graphics.setColor(CLR.WHITE)
  
  buttons.startServer:draw()
  
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
    if buttons.startServer:highlight(mousePointer) then
      if server == nil then
        server = ServerObject(fields.ip:getvalue(), 1992, server_data)
        buttons.startServer.text = "Stop Server"
      else
        server.sender:destroy()
        server = nil
        buttons.startServer.text = "Start Server"
      end
    end
    for i, field in pairs(fields) do
      field:mousepressed(button)
    end
  end
end
