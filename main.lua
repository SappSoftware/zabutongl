debug = false

isServer = false

Sock = require "sock"
Bitser = require "bitser"

HC = require "hc"
Shape = require "hc.shapes"

Gamestate = require "hump.gamestate"
Class = require "hump.class"
Vector = require "hump.vector"
Camera = require "hump.camera"

require "CLR"
require "helper"

require "Tserial"

require "class/ServerObject"
require "class/ClientObject"
require "class/Button"
require "class/FillableField"
require "class/Label"
require "class/Zone"
require "class/Player"
require "class/RectMask"

require "state/server_menu"
require "state/client_menu"
require "state/login"
require "state/register"
require "state/game"

require "zones/zone1"
require "zones/zone2"

sprites = {}

SW = love.graphics.getWidth()
SH = love.graphics.getHeight()

CUR = {}

ZONES = {}

FNT = {}

mousePos = {}

TICK = 0
FPS = 1/60

ipAddress = "10.246.2.249"

function love.load(arg)
  if debug then require("mobdebug").start() end
  Gamestate.registerEvents()
  love.keyboard.setKeyRepeat(true)
  FNT.DEFAULT = love.graphics.newFont(math.floor(SH/64))
  ZONES = loadZones()
  mousePos = HC.point(0,0)
  love.graphics.setFont(FNT.DEFAULT)
  love.graphics.setBackgroundColor(CLR.BLACK)
  CUR.H = love.mouse.getSystemCursor("hand")
  CUR.I = love.mouse.getSystemCursor("ibeam")
  --timeTest1()
  --timeTest2()
  --timeTest3()
  loadImages()
  fpsCounter = Label("FPS", .015, .03, "left", CLR.WHITE)
  if isServer then
    server_data = loadServerData()
    Gamestate.switch(server_menu)
  else 
    client = nil
    Gamestate.switch(login)
  end
end

function love.update(dt)
  
end

function love.draw(dt)

end

function love.keypressed(key)

end

function loadZones()
  local zones = {}
  zones[1] = zone1
  zones[2] = zone2
  
  return zones
end

function loadImages()
  sprites.tile_dark = love.graphics.newImage("images/spr_tile_dark.png")
  sprites.tile_light = love.graphics.newImage("images/spr_tile_light.png")
  
  sprites.tile_dark_highlight = love.graphics.newImage("images/spr_tile_dark_highlight.png")
  sprites.tile_light_highlight = love.graphics.newImage("images/spr_tile_light_highlight.png")
  
  sprites.tile_dark_legal = love.graphics.newImage("images/spr_tile_dark_legal.png")
  sprites.tile_light_legal = love.graphics.newImage("images/spr_tile_light_legal.png")
end

function loadServerData()
  local data = {}
  love.filesystem.setIdentity("Zabutongl_Server")
  if love.filesystem.exists("player_list.lua") then
    local import_string = love.filesystem.read("player_list.lua")
    data = Tserial.unpack(import_string)
  else
    love.filesystem.write("player_list.lua", Tserial.pack(data))
  end
  
  return data
end

function timeTest1()
  local n = 1000000
  local x1 = -68
  local y1 = 26
  local r1 = 100
  
  local x2 = 151
  local y2 = -44
  local r2 = 60
  local time = 0
  local t1 = love.timer:getTime()
  for i = 0, n do
    if ((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1) < 2 * (r1 + r2)) then
      --Collision
    end
  end
  local t2 = love.timer:getTime()
  time = t2 - t1
  print("factored form circle: " .. time)
end

function timeTest2()
  local n = 1000000
  local x1 = 44
  local y1 = -12
  local w1 = 100
  local h1 = 100
  
  local x2 = -20
  local y2 = 27
  local w2 = 100
  local h2 = 100
  local time = 0
  
  local t1 = love.timer:getTime()
  for i = 0, n do
    
    if(x1 + w1 > x2 and x1 < x2 + w2 and y1 + h1 > y2 and y1 < y2 + h2) then
      --Collision
    end
    
    
  end
  local t2 = love.timer:getTime()
  time = (t2 - t1)
  print("square compound: " .. time)
end

function timeTest3()
  local n = 1000000
  local x1 = 44
  local y1 = -12
  local w1 = 100
  local h1 = 100
  
  local x2 = -20
  local y2 = 27
  local w2 = 100
  local h2 = 100
  local time = 0
  
  local t1 = love.timer:getTime()
  for i = 0, n do
    
  if(x1 + w1 > x2) then
    if(x1 < x2 + w2) then
       if(y1 + h1 > y2) then
          if(y1 < y2 + h2) then
             -- Collision!
          end
       end
    end
  end
    
  end
  local t2 = love.timer:getTime()
  time = (t2 - t1)
  print("square nested: " .. time)
end