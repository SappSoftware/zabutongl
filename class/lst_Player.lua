lst_Player = Class{
  init = function(self, username)
    self.username = username
    self.display_text = username
    self.body = {}
    self.index = nil
    self.isHighlighted = false
  end
  
  createBody = function(self, x, y, w, h)
    self.body = HC.rectangle(x,y,w,h)
    setPosition(x,y,w,h)
  end
  
  setPosition = function(self, x, y, w, h)
    self.body:moveTo(x+w/2, y+self.index*love.graphics.getFont():getHeight()+love.graphics.getFont():getHeight()/2)
  end
}