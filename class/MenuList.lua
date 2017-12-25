MenuList = Class{
  init = function(self, x, y, w, h, title, isSorted)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.title = title
    self.items = {}
    self.isSorted = isSorted
  end;
  
  update = function(self, dt)
    
  end;
  
  draw = function(self)
    local i = 0
    for index, item in pairs(self.items) do
      if item.isHighlighted then
        love.graphics.setColor(GREY)
        item.body:draw("fill")
      end
      love.graphics.setColor(WHITE)
      love.graphics.print(item.display_text, self.x, self.y+i*love.graphics.getFont():getHeight())
    end
    
    love.graphics.setColor(WHITE)
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
    love.graphics.setColor(WHITE)
    love.graphics.print(self.title, self.x, self.y-love.graphics.getFont():getHeight())
  end;
  
  mousepressed = function(self, button)
    for i, item in pairs(self.items) do
      if item.isHighlighted then
        item:mousepressed(button)
      end
    end
  end;
  
  highlight = function(self, mousePos)
    for i, item in pairs(self.items) do
      local test = mousePos:collidesWith(item.body)
      if test then
        item.isHighlighted = true
      else 
        item.isHighlighted = false
      end
    end
  end;
  
  addItem = function(self, item)
    table.insert(self.items, item)
    item.index = #self.items
    item:createBody(self.x, self.y, self.w, self.h))
  end;
  
  removeItem = function(self, removedItem)
    table.remove(self.items, removedItem.index, removedItem)
    removedItem = nil
    for i, item in pairs(self.items) do
      item.index = i
      item:setPosition(self.x, self.y, self.w, self.h))
    end
  end;
}