register = {}

local user_data = {}

local fields = {}
local buttons = {}

local passwordsMatch = false

function register:init()
  mousePointer = HC.point(love.mouse.getX(), love.mouse.getY())
  buttons.register = Button(math.floor(SWIDTH/2), math.floor(5*SHEIGHT/8), SWIDTH/8, SHEIGHT/12, "Submit Registration")
  buttons.swapMode = Button(math.floor(SWIDTH/2+SWIDTH/34), math.floor(71*SHEIGHT/100), SWIDTH/15, SHEIGHT/30, "Login")
  
  buttons.register.isSelectable = false
  
  fields.username = FillableField(math.floor(SWIDTH/2), math.floor(SHEIGHT/2-5*SHEIGHT/40), SWIDTH/8, SHEIGHT/20, "Enter Username", false)
  fields.password = FillableField(math.floor(SWIDTH/2), math.floor(SHEIGHT/2-2*SHEIGHT/40), SWIDTH/8, SHEIGHT/20, "Enter Password", false, true)
  fields.confirmPassword = FillableField(math.floor(SWIDTH/2), math.floor(SHEIGHT/2+SHEIGHT/40), SWIDTH/8, SHEIGHT/20, "Confirm Password", false, true)
  
  fields.ip = FillableField(math.floor(SWIDTH/2), math.floor(SHEIGHT/10), SWIDTH/8, SHEIGHT/20, ipAddress, false)
end

function register:update(dt)
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
  
  if fields.password:getvalue() == fields.confirmPassword:getvalue() and string.gsub(fields.password:getvalue(), " ", "") ~= "" and fields.password:getvalue() ~= fields.password.default_text then
    passwordsMatch = true
    if fields.username:getvalue() ~= fields.username.default_text and string.gsub(fields.username:getvalue(), " ", "") ~= "" then
      buttons.register.isSelectable = true
    else
      buttons.register.isSelectable = false
    end
  else
    passwordsMatch = false
    buttons.register.isSelectable = false
  end
  
  if highlightButton then
    love.mouse.setCursor(cur_highlight)
  elseif highlightField then
    love.mouse.setCursor(cur_field)
  else
    love.mouse.setCursor()
  end
end

function register:draw()
  if client ~= nil then
    client:draw()
  end
  
  for i, button in pairs(buttons) do
    button:draw()
  end
  
  for i, field in pairs(fields) do
    field:draw()
  end
  
  if passwordsMatch then
    love.graphics.setColor(GREEN)
    love.graphics.print("O", SWIDTH/2 + SWIDTH/12, SHEIGHT/2 + SHEIGHT/45, 0, 1, 1, 0, math.floor(love.graphics.getFont():getHeight()/3))
  else
    love.graphics.setColor(RED)
    love.graphics.print("X", SWIDTH/2 + SWIDTH/12, SHEIGHT/2 + SHEIGHT/45, 0, 1, 1, 0, math.floor(love.graphics.getFont():getHeight()/3))
  end
end

function register:keypressed(key)
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

function register:textinput(key)
  for i, field in pairs(fields) do
    field:textinput(key)
  end
end

function register:mousepressed(x,y,button,isTouch)
  if button == 1 then
    if buttons.register:highlight(mousePointer) then
      if client ~= nil then
        client.sender:disconnectNow(1)
        client = nil
      end
      user_data.username = fields.username:getvalue()
      user_data.password = fields.password:getvalue()
      client = ClientObject(fields.ip:getvalue(), 1992, user_data, true)
    end
    if buttons.swapMode:highlight(mousePointer) then
      Gamestate.switch(login)
    end
    
    for i, field in pairs(fields) do
      field:mousepressed(button)
    end
  end
end

function register:quit()
  if client ~= nil then
    client.sender:disconnectNow(1)
  end
end

function register:cycleControl(index)
  fields[index]:loseControl()
  if index == "username" then
    fields.password:gainControl()
  elseif index == "password" then
    fields.confirmPassword:gainControl()
  elseif index == "confirmPassword" then
    fields.username:gainControl()
  end
end

