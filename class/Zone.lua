Zone = Class{
  init = function(self, left, right, up, down)
    self.players = {}
    self.npcs = {}
    self.boundaries = {left = left, right = right, up = up, down = down}
    self.boundaryLines = {self.boundaries.left, self.boundaries.up, self.boundaries.right, self.boundaries.up, self.boundaries.right, self.boundaries.down, self.boundaries.left, self.boundaries.down, self.boundaries.left, self.boundaries.up}
    self.isConnected = true
  end;
  
  draw = function(self)
    love.graphics.setColor(CLR.RED)
    love.graphics.line(self.boundaryLines)
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
}

