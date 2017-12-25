Tile = Class{
  init = function(self, boardPosition, tileColor)
    self.boardPosition = boardPosition
    self.body = HC.rectangle(boardPosition.x*TILE_WIDTH, boardPosition.y*TILE_WIDTH,TILE_WIDTH,TILE_WIDTH)
    self.color = tileColor
    self.image = sprites["tile_" .. self.color]
    self.imageHighlight = sprites["tile_" .. self.color .. "_highlight"]
    self.imageLegal = sprites["tile_" .. self.color .. "_legal"]
    self.activeImage = self.image
    self.piece = nil
    self.isHighlight = false
  end;
  
  draw = function(self)
    love.graphics.draw(self.activeImage, self.boardPosition.x*TILE_WIDTH, self.boardPosition.y*TILE_WIDTH)
  end;
  
  highlight = function(self, mousePoint)
    local test = mousePoint:collidesWith(self.body)
    if test then
      self.activeImage = self.imageHighlight
    else
      self.activeImage = self.image
    end
    
    return test
  end;
}