game = {}

local buttons = {}
local fields = {}
local labels = {}

local ui_square = {}

local camera = {}
local zoom = 1

function game:init()
  camera = Camera(0, 0)
  
  ui_square = HC.rectangle(0, SW, SW, SH-SW)
  labels.coord = Label("(" .. client.player.pos.x .. ", " .. client.player.pos.y .. ")", .1, .1, "left", CLR.BLACK)
end

function game:enter(from)
  love.graphics.setBackgroundColor(CLR.WHITE)
  mousePos = HC.point(love.mouse.getX(), love.mouse.getY())

  camera:lookAt(0, 0)
end

function game:update(dt)
  self:handleMouse()
  
  client:update_game(dt)
  
  camera:lookAt(client.player.pos:unpack())
  
  labels.coord:settext("(" .. client.player.pos.x .. ", " .. client.player.pos.y .. ")")
end

function game:keypressed(key)
  for pos, field in pairs(fields) do
    field:keypressed(key)
  end
  
  if key == "-" then
    zoom = zoom - .1
    camera:zoomTo(zoom)
  end
  
  if key == "=" then
    zoom = zoom + .1
    camera:zoomTo(zoom)
  end
  
  if key == "escape" then
    --Gamestate.switch(main_menu)
  end
end

function game:textinput(text)
  for pos, field in pairs(fields) do
    field:textinput(text)
  end
end

function game:mousepressed(mousex, mousey, mouseButton)
  if mouseButton == 1 then
    if ui_square:contains(mousex, mousey) then
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
end


function game:draw()
  camera:draw(self.draw_game)

  self:drawUI()
  
  self:drawDebug()
end

function game:draw_game()
  client.activeZone:draw()
end

function game:drawUI()
  love.graphics.setColor(CLR.BLACK)
  ui_square:draw("fill")
  love.graphics.setColor(CLR.WHITE)
  ui_square:draw("line")
  
  for pos, button in pairs(buttons) do
    button:draw()
  end
  for pos, field in pairs(fields) do
    field:draw()
  end
  for pos, label in pairs(labels) do
    label:draw()
  end
end

function game:drawDebug()
  love.graphics.setColor(CLR.BLACK)
  love.graphics.print(love.timer.getFPS(), 10, 10)
end

function game:handleMouse()
  mousePos:moveTo(love.mouse.getX(), love.mouse.getY())
  local highlightButton = false
  local highlightField = false
  
  for key, button in pairs(buttons) do
    if button:highlight(mousePos) then
      highlightButton = true
    end
  end
  
  for key, field in pairs(fields) do
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

function game:quit()
  if client ~= nil then
    client.sender:disconnectNow(1)
  end
end