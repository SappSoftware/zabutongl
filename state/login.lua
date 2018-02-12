login = {}

local user_data = {}

local fields = {}
local buttons = {}
local labels = {}

function login:init()
  buttons.login = Button(.5, 5/8, 1/8, 1/12, "Connect to Server")
  buttons.swapMode = Button(0.53, .71, 1/15, 1/30, "Register")
  
  buttons.login.isSelectable = false
  
  fields.username = FillableField(1/2, .45, 1/8, 1/20, "Enter Username", false, true)
  fields.password = FillableField(.5, .525, 1/8, 1/20, "Enter Password", false, true, 100, true)
  
  fields.ip = FillableField(.5, .1, 1/8, 1/20, ipAddress, false)
end

function login:enter(from)
  
end

function login:update(dt)
  
  TICK = TICK + dt
  self:handleMouse(dt)
  
  if TICK >= FPS then
    if client ~= nil then
      client:update_menu(dt)
    end
    
    for i, button in pairs(buttons) do
      button:update(dt)
    end
    
    for _, field in pairs(fields) do
      field:update(TICK)
    end
    
    if fields.username:getvalue() ~= fields.username.default_text and string.gsub(fields.username:getvalue(), " ", "") ~= "" 
    and fields.password:getvalue() ~= fields.password.default_text and string.gsub(fields.password:getvalue(), " ", "") ~= "" then
      buttons.login.isSelectable = true
    else
      buttons.login.isSelectable = false
    end
    TICK = 0
  end
end

function login:draw()
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

function login:keypressed(key)
  for i, field in pairs(fields) do
    field:keypressed(key)
  end
  
  if key == "tab" then
    local hasSwapped = false
    for i, field in pairs(fields) do
      if not hasSwapped and field.hasControl then
        self:cycleControl(i)
        hasSwapped = true
      end
    end
  end
  
  if key == "escape" then
    love.event.quit()
  end
end

function login:textinput(key)
  for i, field in pairs(fields) do
    field:textinput(key)
  end
end

function login:mousepressed(x,y,button,isTouch)
  if button == 1 then
    if buttons.login:highlight(mousePos) then
      if client ~= nil then
        client.sender:disconnectNow(1)
        client = nil
      end
      user_data.username = fields.username:getvalue()
      user_data.password = fields.password:getvalue()
      client = ClientObject(fields.ip:getvalue(), 1992, user_data, false)
    end
    if buttons.swapMode:highlight(mousePos) then
      Gamestate.switch(register)
    end
    
    for i, field in pairs(fields) do
      field:mousepressed(button)
    end
  end
end

function login:quit()
  if client ~= nil then
    client.sender:disconnectNow(1)
  end
end

function login:cycleControl(index)
  fields[index]:loseControl()
  if index == "username" then
    fields.password:gainControl()
  elseif index == "password" then
    fields.username:gainControl()
  end
end

function login:handleMouse(dt)
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