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

require "class/Board"
require "class/ServerObject"
require "class/ClientObject"
require "class/Tile"
require "class/Button"
require "class/FillableField"

require "state/server_menu"
require "state/client_menu"
require "state/login"
require "state/register"

sprites = {}

SWIDTH = love.graphics.getWidth()
SHEIGHT = love.graphics.getHeight()
WHITE = {255,255,255}
BLACK = {0,0,0}
RED = {255,0,0}
GREEN = {0,255,0}
GREY = {177,177,177}

FONT_SIZE = 24

mousePointer = {}

ipAddress = "192.168.0.16"

function love.load(arg)
  if debug then require("mobdebug").start() end
  Gamestate.registerEvents()
  love.keyboard.setKeyRepeat(true)
  TILE_WIDTH = math.floor(SWIDTH/15)
  PIECE_WIDTH = math.floor(TILE_WIDTH*10/12)
  love.graphics.setFont(love.graphics.newFont(math.floor(SHEIGHT/64)))
  love.graphics.setBackgroundColor(BLACK)
  cur_highlight = love.mouse.getSystemCursor("hand")
  cur_field = love.mouse.getSystemCursor("ibeam")
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
  love.filesystem.setIdentity("Concussion_Server")
  if love.filesystem.exists("player_list.lua") then
    import_string = love.filesystem.read("player_list.lua")
    data = Tserial.unpack(import_string)
  else
    love.filesystem.write("player_list.lua", Tserial.pack(data))
  end
  
  return data
end