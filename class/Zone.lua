Zone = Class{
  init = function(self, zone_id)
    self.players = {}
    self.npcs = {}
    self.zone_id = zone_id
    self.masks = self:initializeMasks(zone_id)
    self.isConnected = true
  end;
  
  initializeMasks = function(self, zone_id)
    local masks = {}
    for i, data in ipairs(ZONES[zone_id].masks) do
      local box = HC.rectangle(data.x, data.y, data.w, data.h)
      table.insert(masks, box)
    end
    return masks
  end;
  
  draw = function(self)
    love.graphics.setColor(CLR.RED)
    
    for i, mask in ipairs(self.masks) do
      mask:draw("line")
    end
    for i, player in pairs(self.players) do
      player:draw()
    end
    for i, npc in pairs(self.npcs) do
      npc:draw()
    end
  end;
  
  update = function(self)
    
  end;
  
  updatePlayer = function(self, data, index)
    self.players[index]:updateExt(data.x, data.y, data.dir)
  end;
  
  addPlayer = function(self, player, index)
    table.insert(self.players, index, player)
  end;
  
  removePlayer = function(self, index)
    table.remove(self.players, index)
  end;
}

