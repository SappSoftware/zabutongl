Button = Class{
  init = function(self, x, y, w, h, text)
    self.w = w
    self.h = h
    self.x = x - w/2
    self.y = y - h/2
    self.body = HC.rectangle(self.x, self.y, w, h)
    self.text = text
    self.xOffset = 3*love.graphics.getLineWidth()
    self.yOffset = self.h/2 - math.floor(love.graphics.getFont():getWidth(self.text)/(self.w-2*self.xOffset))*love.graphics.getFont():getHeight()/2
    self.isActive = true
    self.isHighlighted = false
    self.isSelectable = true
  end;
  
  draw = function(self)
    if self.isActive then
      if self.isSelectable then
        love.graphics.setColor(WHITE)
        self.body:draw("line")
        love.graphics.setColor(WHITE)
        love.graphics.printf(self.text, self.x+self.xOffset, self.y+self.yOffset, self.w-2*self.xOffset, "center", 0, 1, 1, 0, love.graphics.getFont():getHeight()/2)
      else
        love.graphics.setColor(GREY)
        self.body:draw("line")
        love.graphics.setColor(GREY)
        love.graphics.printf(self.text, self.x+self.xOffset, self.y+self.yOffset, self.w-2*self.xOffset, "center", 0, 1, 1, 0, love.graphics.getFont():getHeight()/2)
      end
    end
  end;
  
  highlight = function(self, mousePos)
    if self.isActive then
      if not self.isSelectable then return false end
      local test = mousePos:collidesWith(self.body)
      if test then
        self.isHighlighted = true
      else 
        self.isHighlighted = false
      end
      return test
    end
    self.isHighlighted = false
    return false
  end;
  
  action = function(self)
    
  end;
}