Player = Class{
  init = function(self, player_id, parentZone)
    self.player_id = player_id
    self.pos = Vector(0, 0)
    self.dx = 0
    self.dy = 0
    self.radius = 50
    self.speed = 300
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
    if love.keyboard.isDown("t") then
      self.speed = 10
    else
      self.speed = 150
    end
    self.velocity.x = self.dx*self.speed
    self.velocity.y = self.dy*self.speed
    self.velocity:trimInplace(self.speed*dt)
    local nextpos = Vector(0,0)
    if self.velocity:len2() ~= 0 then
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
            local norm1 = math.abs(shunt*object.normals[1])
            local norm2 = math.abs(shunt*object.normals[2])
            local perp = Vector(0,0)
            if norm1 > norm2 then
              perp = object.normals[1]
            else
              perp = object.normals[2]
            end
            table.insert(collides, {perp = perp, shunt = shunt, length = length, object = object})
            --[[
            diff = Vector(dx,dy)
            nextpos = nextpos + diff
            self.mask:moveTo(nextpos:unpack())
            ]]--
          end
        end
        
        ------------------------METHOD FOUR----------------------------------
        for i = 1, 3 do
          for i, collision in ipairs(collides) do
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