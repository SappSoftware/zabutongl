Zone = Class{
  init = function(self, zone_id, players_data)
    self.players_data = players_data
    self.players = self:initializePlayers()
    self.npcs = {}
    self.zone_id = zone_id
    self.masks = self:initializeMasks(zone_id)
    self.isConnected = true
  end;
  
  initializePlayers = function(self)
    local returnTable = {}
    for index, player_data in pairs(self.players_data) do
      returnTable[index] = Player(player_data.player_id, self, player_data.x, player_data.y, player_data.dir)
    end
    return returnTable
  end;
  
  initializeMasks = function(self, zone_id)
    local masks = {}
    for i, data in ipairs(ZONES[zone_id].masks) do
      local box = RectMask(data.x, data.y, data.w, data.h, data.rot)
      table.insert(masks, box)
    end
    return masks
  end;
  
  draw = function(self, player_id)
    love.graphics.setColor(CLR.RED)
    
    for i, mask in ipairs(self.masks) do
      mask:draw("line")
    end
    for i, player in pairs(self.players) do
      if i ~= player_id then
        player:draw()
      end
    end
    
    if player_id ~= nil then
      self.players[player_id]:draw()
    end
    
    for i, npc in pairs(self.npcs) do
      npc:draw()
    end
  end;
  
  update = function(self, dt, player_index)
    for index, player_data in pairs(self.players_data) do
      if index ~= player_index then
        self:updatePlayer(player_data, index)
      end
    end
  end;
  
  updatePlayer = function(self, data, index)
    if self.players[index] ~= nil then
      self.players[index]:updateExt(data.x, data.y, data.dir)
    else
      self:instantiatePlayer(data, index)
    end
  end;
  
  addPlayer = function(self, player, index)
    local data = {x = player.pos.x, y = player.pos.y, dir = player.dir, player_id = player.player_id}
    player.activeZone = self
    self.players_data[index] = data
    self.players[index] = player
  end;
  
  instantiatePlayer = function(self, data, index)
    local player = Player(data.player_id, self, data.x, data.y, data.dir)
    self.players[index] = player
  end;
  
  removePlayer = function(self, index)
    if self.players[index] ~= nil then
      self.players_data[index] = nil
      self.players[index] = nil
    end
  end;
}