Player = Class{
  init = function(self, player_id, parentZone, x, y, dir)
    self.player_id = player_id
    self.pos = Vector(x or 0, y or 0)
    self.dx = 0
    self.dy = 0
    self.radius = 40
    self.speed = 400
    self.accelC = 50
    self.acceleration = Vector(0,0)
    self.velocity = Vector(0,0)
    self.dir = dir or 0
    self.dirLine = {self.pos.x, self.pos.y, self.pos.x + math.cos(self.dir)*self.radius, self.pos.y + math.sin(self.dir)*self.radius}
    self.label = Label(self.player_id, self.pos.x, self.pos.y, "center", CLR.BLACK)
    self.mask = HC.circle(self.pos.x, self.pos.y, self.radius)
    self.parentZone = parentZone or false
  end;
  
  draw = function(self)
    love.graphics.setColor(CLR.GREY)
    self.mask:draw("fill")
    love.graphics.setColor(CLR.RED)
    self.mask:draw("line")
    love.graphics.line(self.dirLine)
    self.label:draw()
  end;
  
  update = function(self, dt, mousePos)
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
    if self.dx == 0 and self.dy == 0 then
      self.acceleration = -self.velocity*self.accelC*dt*.3
    else
      self.acceleration.x = self.dx
      self.acceleration.y = self.dy
      self.acceleration:normalizeInplace()
      self.acceleration = self.acceleration*self.accelC*dt
    end
    
    self.velocity = roundTo(self.velocity + self.acceleration, 2)
    
    self.velocity:trimInplace(self.speed*dt)
    local nextpos = Vector(0,0)
    --if self.velocity:len2() ~= 0 then
      nextpos = self.pos + self.velocity
      
      self.mask:moveTo(nextpos:unpack())
      
      if self.parentZone ~= false then
        local diff = Vector(0,0)
        local collides = {}
        local collisionResolved = true
        for i, object in ipairs(self.parentZone.masks) do
          local test, dx, dy = self.mask:collidesWith(object.mask)
          --attempt saving all collisions, resolve as a whole rather than in order
          if test == true then
            collisionResolved = false
            
            local shunt = Vector(dx,dy)
            local length = shunt:len2()
            table.insert(collides, {shunt = shunt, length = length, object = object})
          end
        end
        
        ------------------------METHOD FOUR----------------------------------
        local testCases = {}
        for i, collision in ipairs(collides) do
          local index = 1
          for j, comparison in ipairs(collides) do
            if collision.length < comparison.length then
              index = index + 1
            end
          end
          testCases[index] = collision
        end
        
        for i = 1, 2 do
          for i, collision in ipairs(testCases) do
            local test, dx, dy = self.mask:collidesWith(collision.object.mask)
            if test == true then
              local shunt = Vector(dx,dy)
              nextpos = nextpos + shunt
            end
            self.mask:moveTo(nextpos:unpack())
          end
        end
        ------------------------METHOD FOUR----------------------------------
        ------------------------METHOD THREE---------------------------------
        --[[
        local testCases = {}
        for i, collision in ipairs(collides) do
          local index = 1
          for j, comparison in ipairs(collides) do
            if collision.length > comparison.length then
              index = index + 1
            end
          end
          testCases[index] = collision
        end
        
        for i, collision in ipairs(testCases) do
          local numCollisions = #testCases
          local finalpos = nextpos + collision.shunt
          
          self.mask:moveTo(finalpos:unpack())
          for j, comparison in ipairs(testCases) do
            local test, dx, dy = self.mask:collidesWith(comparison.object.mask)
            if test == true then
              local shunt = Vector(dx,dy)
              local slide = shunt:projectOn(collision.perp)
              finalpos = finalpos + slide
              numCollisions = numCollisions - 1
            else
              numCollisions = numCollisions - 1
            end
          end
          if numCollisions == 0 then
            nextpos = finalpos
            break
          end
        end
        ------------------------METHOD THREE---------------------------------
        ]]--
        -------------------------METHOD TWO----------------------------------
        --[[
        if #collides == 1 then
          diff = Vector(collides[1].dx,collides[1].dy)
          nextpos = nextpos + diff
        elseif #collides == 2 then
          local vectorA = Vector(collides[1].dx, collides[1].dy)
          local vectorB = Vector(collides[2].dx, collides[2].dy)
          local theta = math.abs(vectorA:angleTo(vectorB))
          if theta > math.pi then
            theta = theta - math.pi
          end
          
          if theta < 0.01 then
            if vectorA:len2() > vectorB:len2() then
              diff = vectorA
            else
              diff = vectorB
            end
            nextpos = nextpos + diff
          elseif theta > math.pi/2 + 0.01 then
            local testpos = nextpos
            local numCollides = #collides
            while collisionResolved == false do
              if numCollides == 0 then
                collisionResolved = true
              else
                testpos = testpos - 0.1*self.velocity
                self.mask:moveTo(testpos:unpack())
                numCollides = #collides
                for i, object in ipairs(collides) do
                  local test, dx, dy = self.mask:collidesWith(object.mask)
                  if test == false then
                    numCollides = numCollides - 1
                  end
                end
              end
            end
            nextpos = testpos
          elseif theta < math.pi/2 - .01 then
            if vectorA:len2() > vectorB:len2() then
              diff = vectorA
            else
              diff = vectorB
            end
            nextpos = nextpos + diff
          elseif theta < math.pi/2 + .01 then
            diff = vectorA + vectorB
            nextpos = nextpos + diff
          else
            nextpos = self.pos
          end
        end
        -------------------------METHOD TWO----------------------------------
        ]]--
        -------------------------METHOD ONE----------------------------------
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
        -------------------------METHOD ONE----------------------------------
        ]]--
      end
      
      self.pos = roundTo(nextpos,1)
      self.mask:moveTo(self.pos:unpack())
    --end
    local mousex, mousey = mousePos:center()
    self.dir = math.atan2(mousey - self.pos.y, mousex - self.pos.x)
    self.dirLine = {self.pos.x, self.pos.y, self.pos.x + math.cos(self.dir)*self.radius, self.pos.y + math.sin(self.dir)*self.radius}
    self.label:setposition(self.pos.x, self.pos.y)
  end;
  
  updateExt = function(self, x, y, dir)
    self.pos.x = x
    self.pos.y = y
    self.dir = dir
    self.dirLine = {self.pos.x, self.pos.y, self.pos.x + math.cos(self.dir)*self.radius, self.pos.y + math.sin(self.dir)*self.radius}
    self.label:setposition(self.pos.x, self.pos.y)
    self.mask:moveTo(self.pos:unpack())
  end;
  
  getUpdate = function(self)
    return self.pos.x, self.pos.y, self.dir, self.player_id
  end;
}