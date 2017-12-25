Board = Class{
  init = function(self)
    self.tiles = {}
    self:setTiles()
  end;
  
  setTiles = function(self)
    for column = 1,13 do
      self.tiles[column] = {}
      for row = 1,8 do
        local boardPosition = Vector(column,row)
        if boardPosition.x % 2 == boardPosition.y % 2 then
          self.tiles[column][row] = Tile(boardPosition, "black")
        else
          self.tiles[column][row] = Tile(boardPosition, "white")
        end
      end
    end
  end;
  
  draw = function(self)
    for i, column in pairs(self.tiles) do
      for j, tile in pairs(column) do
        tile:draw()
      end
    end
  end;
  
  highlight = function(self, mousePoint)
    local isHighlight = false
    for i, column in pairs(self.tiles) do
      for j, tile in pairs(column) do
        if tile:highlight(mousePoint) then
          local isHighlight = true
        end
      end
    end
    
    return isHighlight
  end;
}