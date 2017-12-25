FillableField = Class{__includes = Button,
  init = function(self, x, y, w, h, default_text, isNumber)
    Button.init(self, x, y, w, h, default_text)
    self.default_text = default_text
    self.isNumber = isNumber
    self.hasControl = false
    self.linePulse = FillableField.pulseTime
    self.line = false
    self.fontHeight = love.graphics.getFont():getHeight()
    self.isPrivate = false
  end;
  
  init = function(self, x, y, w, h, default_text, isNumber, isPrivate)
    Button.init(self, x, y, w, h, default_text)
    self.default_text = default_text
    self.isNumber = isNumber
    self.hasControl = false
    self.linePulse = FillableField.pulseTime
    self.line = false
    self.fontHeight = love.graphics.getFont():getHeight()
    self.isPrivate = isPrivate
  end;
  pulseTime = 0.7,
  
  mousepressed = function(self, button)
    if self.isActive then
      if self.hasControl and not self.isHighlighted then
        self:loseControl()
      end
      
      if not self.hasControl and self.isHighlighted then
        self:gainControl()
      end
    end
  end;
  
  textinput = function(self, key)
    if self.hasControl then
      if self.isNumber then
        local toAdd = tonumber(key)
        if toAdd then
          self.text = tonumber(self.text .. toAdd)
        end
      else
        local toAdd = key
        if toAdd then
          self.text = self.text .. toAdd
        end
      end
    end
  end;
  
  keypressed = function(self, key)
    if self.hasControl then
      if key == "backspace" then
        self.text = tostring(self.text):sub(1, -2)
        if self.isNumber then
          self.text = tonumber(self.text)
        end
      end
      if key == "return" then
        self.hasControl = false
      end
    end
  end;
  
  update = function(self, dt)
    if self.hasControl then
      self.linePulse = self.linePulse - dt
      if self.linePulse <= 0 then
        self.linePulse = FillableField.pulseTime
        self.line = not self.line
      end
    end
  end;
  
  draw = function(self)
    if self.isActive then
      love.graphics.setColor(WHITE)
      self.body:draw("line")
      love.graphics.setColor(WHITE)
      local linex = 0
      if self.isPrivate and self.text ~= self.default_text then
        local display_text = string.rep("*", string.len(self.text))
        love.graphics.printf(display_text, self.x+self.xOffset, self.y+self.yOffset, self.w-self.xOffset, "left", 0, 1, 1, 0, love.graphics.getFont():getHeight()/2)
        linex = self.x+self.xOffset+love.graphics.getFont():getWidth(display_text)
      else
        love.graphics.printf(self.text, self.x+self.xOffset, self.y+self.yOffset, self.w-self.xOffset, "left", 0, 1, 1, 0, love.graphics.getFont():getHeight()/2)
        linex = self.x+self.xOffset+love.graphics.getFont():getWidth(self.text)
      end
      if self.hasControl and self.line then
        love.graphics.setColor(WHITE)
        love.graphics.line(linex, self.y+self.yOffset-self.fontHeight/2, linex, self.y+self.yOffset+self.fontHeight/2)
      end
    end
  end;
  
  gainControl = function(self)
    self.hasControl = true
    if self.text == self.default_text then
      self.text = ""
    end
    self.linePulse = FillableField.pulseTime
    self.line = true
  end;
  
  loseControl = function(self)
    self.hasControl = false
    if self.text == "" then
      self.text = self.default_text
    end
  end;
  
  getvalue = function(self)
    if self.isNumber then
      return tonumber(self.text)
    else
      return tostring(self.text)
    end
  end;
}