RectMask = Class{
  init = function(self, x, y, w, h, rotation)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.rotdeg = rotation or 0
    self.rotrad = self.rotdeg*math.pi/180
    self.mask = HC.rectangle(self.x, self.y, self.w, self.h)
    self.mask:setRotation(self.rotrad)
    self.normals = self:getNormals()
  end;
  
  getNormals = function(self)
    local normals = {}
    local unit = Vector(1,0)
    for i = 0, 3 do
      table.insert(normals, unit:rotated(self.rotrad + i*math.pi/2))
    end
    return normals
  end;
  
  draw = function(self)
    self.mask:draw("line")
  end;
}