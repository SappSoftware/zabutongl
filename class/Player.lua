Player = Class{
  init = function(self, player_id, parentZone)
    self.player_id = player_id
    self.pos = Vector(0, 0)
    self.dx = 0
    self.dy = 0
    self.radius = 50
    self.speed = 20
    self.velocity = Vector(0,0)
    self.dir = 0
    self.mask = HC.circle(self.pos.x, self.pos.y, self.radius)
    self.parentZone = parentZone or false
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
      self.dy = self.dy - 1
    end
    if love.keyboard.isDown("s") then
      self.dy = self.dy + 1
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
    local nextpos = Vector(0,0)
    if self.velocity:len2() ~= 0 then
      nextpos = self.pos + self.velocity
      
      self.mask:moveTo(nextpos:unpack())
      
      if self.parentZone ~= false then
        local diff = Vector(0,0)
        local collides = {}
        local collisionResolved = true
        for i, object in ipairs(self.parentZone.masks) do
          local test, dx, dy = self.mask:collidesWith(object)
          --attempt saving all collisions, resolve as a whole rather than in order
          if test == true then
            --collisionResolved = false
            table.insert(collides, {dx = dx, dy = dy, mask = object})

            diff = Vector(dx,dy)
            nextpos = nextpos + diff
            self.mask:moveTo(nextpos:unpack())

          end
        end
        if #collides == 2 then
          local a = ""
        end
        --[[
        if #collides > 1 then
          local numIters = 0
          while collisionResolved == false do
            numIters = numIters + 1
            local noneWorked = true
            for i, object in ipairs(collides) do
              local isGoodPush = true
              local testdiff = Vector(object.dx, object.dy)
              local testpos = nextpos + testdiff
              self.mask:moveTo(testpos:unpack())
              for j, subject in ipairs(collides) do
                local isCollide = self.mask:collidesWith(subject.mask)
                if isCollide == true then
                  isGoodPush = false
                  break
                end
              end
              if isGoodPush == true then
                collisionResolved = true
                noneWorked = false
                nextpos = testpos
                break 
              end
            end
            if noneWorked == true then
              for i, object in ipairs(collides) do
                local test, dx, dy = self.mask:collidesWith(object.mask)
                if test then
                  local diff = Vector(dx,dy)
                  nextpos = nextpos + diff
                  self.mask:moveTo(nextpos:unpack())
                end
              end
              collisionResolved = true
            end
            if numIters > 10 then 
              nextpos = self.pos
              break
            end
          end
        elseif #collides == 1 then
          local diff = Vector(collides[1].dx,collides[1].dy)
          nextpos = nextpos + diff
          self.mask:moveTo(nextpos:unpack())
        end
        ]]--
      end
      
      self.pos = nextpos
      self.mask:moveTo(self.pos:unpack())
    end
  end;
  
  updateExt = function(self, x, y, dir)
    self.pos.x = x
    self.pos.y = y
    self.dir = dir
    self.mask:moveTo(self.pos:unpack())
  end;
  
  getUpdate = function(self)
    return self.pos.x, self.pos.y, self.dir, self.player_id
  end;
}