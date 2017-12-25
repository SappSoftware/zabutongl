debug = false

isServer = false

Sock = require "sock"
Bitser = require "bitser"

HC = require "hc"
Shape = require "hc.shapes"

Gamestate = require "hump.gamestate"
Class = require "hump.class"
Vector = require "hump.vector"

require "Tserial"

require "class/ServerObject"
require "class/ClientObject"
require "class/Button"
require "class/FillableField"
require "class/Label"

require "state/server_menu"
require "state/client_menu"
require "state/login"
require "state/register"

sprites = {}

SW = love.graphics.getWidth()
SH = love.graphics.getHeight()

CLR = {}
CLR.WHITE = {255,255,255}
CLR.BLACK = {0,0,0}
CLR.RED = {255,0,0}
CLR.GREEN = {0,255,0}
CLR.GREY = {177,177,177}

CUR = {}

FONT_SIZE = 24

mousePointer = {}

ipAddress = "192.168.0.16"

function love.load(arg)
  if debug then require("mobdebug").start() end
  Gamestate.registerEvents()
  love.keyboard.setKeyRepeat(true)
  love.graphics.setFont(love.graphics.newFont(math.floor(SH/64)))
  love.graphics.setBackgroundColor(CLR.BLACK)
  CUR.H = love.mouse.getSystemCursor("hand")
  CUR.I = love.mouse.getSystemCursor("ibeam")
  loadImages()
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
    import_string = love.filesystem.read("player_list.lua")
    data = Tserial.unpack(import_string)
  else
    love.filesystem.write("player_list.lua", Tserial.pack(data))
  end
  
  return data
end