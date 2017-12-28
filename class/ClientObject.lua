ClientObject = Class{
  init = function(self, ip, port, user_data, registering)
    self.tickRate = 1/60
    self.tick = 0
    self.sender = Sock.newClient(ip, port)
    self.sender:setSerialization(Bitser.dumps, Bitser.loads)
    self.user_data = user_data
    self.isRegistering = registering
    self.isConnected = false
    self:setCallbacks()
    self.sender:connect()
    self.activeZone = {}
  end;
  
  setCallbacks = function(self)
    self.sender:setSchema("playerInfo", {
      "index",
      "username"
    })
    
    self.sender:setSchema("updatePlayer", {
      "x",
      "y",
      "dir",
      "player_id"
    })
    
    self.sender:on("connect", function(data)
      if self.isRegistering then
        self.sender:send("register", self.user_data)
      else
        self.sender:send("login", self.user_data)
      end
    end)
    
    self.sender:on("register", function(data)
      if data == true then
        Gamestate.switch(client_menu)
      else
        self.sender:disconnectNow(1)
      end
    end)
    
    self.sender:on("login", function(data)
      if data == true then
        Gamestate.switch(client_menu)
      else
        self.sender:disconnectNow(1)
      end
    end)
  end;
  
  update = function(self, dt)
    self.sender:update()
    
    if self.sender:getState() == "connected" then
      self.tick = self.tick + dt
    end
    
    if self.tick >= self.tickRate then
      self.tick = 0
      
    end
  end;
  
  draw = function(self)
    love.graphics.print(self.sender:getState(), 5, 5)
  end;
  }