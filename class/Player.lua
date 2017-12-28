Player = Class{
  init = function(self, player_id)
    self.player_id = player_id
    self.pos = Vector(0, 0)
    self.dx = 0
    self.dy = 0
    self.radius = 50
    self.speed = 20
    self.velocity = Vector(0,0)
    self.dir = 0
    self.mask = HC.circle(self.pos.x, self.pos.y, self.radius)
  end;
  
  draw = function(self)
    love.graphics.setColor(CLR.GREY)
    self.mask:draw("fill")
    love.graphics.setColor(CLR.RED)
    self.mask:draw("line")
  end;
  
  update = function(self, dt)
    self.dx = 0
    self.dy = 0
    if love.keyboard.isDown("w") then
      self.dy = self.dy + 1
    end
    if love.keyboard.isDown("s") then
      self.dy = self.dy - 1
    end
    if love.keyboard.isDown("a") then
      self.dx = self.dx - 1
    end
    if love.keyboard.isDown("d") then
      self.dx = self.dx + 1
    end
    self.velocity.x = self.dx*self.speed
    self.velocity.y = self.dy*self.speed
    self.velocity:trimInplace(self.speed)
    self.pos = self.pos + self.velocity
    self.mask:moveTo(self.pos:unpack())
  end;
}