login = {}

local user_data = {}

local fields = {}
local buttons = {}
local labels = {}

function login:init()
  mousePointer = HC.point(love.mouse.getX(), love.mouse.getY())
  buttons.login = Button(.5, 5/8, 1/8, 1/12, "Connect to Server")
  buttons.swapMode = Button(0.53, .71, 1/15, 1/30, "Register")
  
  buttons.login.isSelectable = false
  
  fields.username = FillableField(1/2, .45, 1/8, 1/20, "Enter Username", false)
  fields.password = FillableField(.5, .525, 1/8, 1/20, "Enter Password", false, true)
  
  fields.ip = FillableField(.5, .1, 1/8, 1/20, ipAddress, false)
end

function login:update(dt)
  if client ~= nil then
    client:update(dt)
  end
  
  local highlightButton = false
  local highlightField = false
  mousePointer:moveTo(love.mouse.getX(), love.mouse.getY())
  
  for i, button in pairs(buttons) do
    if button:highlight(mousePointer) then
      highlightButton = true
    end
  end
  
  for i, field in pairs(fields) do
    field:update(dt)
    if field:highlight(mousePointer) then
      highlightField = true
    end
  end
  
  if fields.username:getvalue() ~= fields.username.default_text and string.gsub(fields.username:getvalue(), " ", "") ~= "" 
  and fields.password:getvalue() ~= fields.password.default_text and string.gsub(fields.password:getvalue(), " ", "") ~= "" then
    buttons.login.isSelectable = true
  else
    buttons.login.isSelectable = false
  end
  
  if highlightButton then
    love.mouse.setCursor(CUR.H)
  elseif highlightField then
    love.mouse.setCursor(CUR.I)
  else
    love.mouse.setCursor()
  end
end

function login:draw()
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
    if buttons.login:highlight(mousePointer) then
      if client ~= nil then
        client.sender:disconnectNow(1)
        client = nil
      end
      user_data.username = fields.username:getvalue()
      user_data.password = fields.password:getvalue()
      client = ClientObject(fields.ip:getvalue(), 1992, user_data, false)
    end
    if buttons.swapMode:highlight(mousePointer) then
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
