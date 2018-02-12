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
    self.player = {}
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
    
    self.sender:on("joinZone", function(data)
      self.activeZone = Zone(data.zone_id, data.players_data)
      self.player = self.activeZone.players[self.user_data.username]
    end)
    
    self.sender:on("updatePlayers", function(data)
      self.activeZone.players_data = data
    end)
    
    self.sender:on("removePlayer", function(data)
      self.activeZone:removePlayer(data)
    end)
  end;
  
  update_menu = function(self, dt)
    self.tick = self.tick + dt
    
    if self.tick >= self.tickRate then
      self.sender:update(self.tick)
      
      self.tick = 0
    end
  end;
  
  update_game = function(self, dt, mousePos)
    self.tick = self.tick + dt
    
    if self.tick >= self.tickRate then
      self.sender:update(self.tick)
      
      if self.activeZone ~= {} then
        self.player:update(self.tick, mousePos)
        
        self.activeZone:update(self.tick, self.user_data.username)
        
        local data = {self.player:getUpdate()}
        self.sender:send("updatePlayer", data)
      end
      self.tick = 0
    end
  end;
  
  draw = function(self)
    love.graphics.print(self.sender:getState(), 5, 5)
  end;
  
  draw_game = function(self)
    self.activeZone:draw(self.player.player_id)
  end;
  
  joinZone = function(self)
    self.sender:send("joinZone", self.user_data.username)
  end;
  }