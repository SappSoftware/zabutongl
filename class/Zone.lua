Zone = Class{
  init = function(self)
    self.players = {}
    self.npcs = {}
    self.boundaries = {left = -5000, right = 5000, up = 5000, down = -5000}
    self.boundaryLines = {self.boundaries.left, self.boundaries.up, self.boundaries.right, self.boundaries.up, self.boundaries.right, self.boundaries.down, self.boundaries.left, self.boundaries.down}
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
  
  addPlayer = function(self, player, index)
    table.insert(self.players, index, player)
  end;
}

