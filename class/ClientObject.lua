ClientObject = Class{
  init = function(self, ip, port, user_data, registering)
    self.tickRate = 1/60
    self.tick = 0
    self.sender = Sock.newClient(ip, port)
    self.sender:setSerialization(Bitser.dumps, Bitser.loads)
    self.playerList = {}
    self.lobbyList = {}
    self.user_data = user_data
    self.isRegistering = registering
    self.isConnected = false
    self:setCallbacks()
    self.sender:connect()
  end;
  
  setCallbacks = function(self)
    self.sender:setSchema("playerInfo", {
      "index",
      "username"
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
    
    self.sender:on("updateMenuLists", function(data)
      self.playerList = data.playerList
      self.lobbyList = data.lobbyList
    end)
    
    self.sender:on("addPlayer", function(index)
      
    end)
    
    self.sender:on("playerNum", function(num)
      
    end)
    
    self.sender:on("playerState", function(data)
      
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
  
  drawPlayerList = function(self,x,y)
    love.graphics.setColor(WHITE)
    local i = 0
    for id, player in pairs(self.playerList) do
      love.graphics.print(player, x, y+i*love.graphics.getFont():getHeight())
      i = i + 1
    end
    
    love.graphics.setColor(WHITE)
    love.graphics.rectangle("line", x, y, SW/4, SH/2)
    love.graphics.setColor(WHITE)
    love.graphics.print("Players Online:", x, y-love.graphics.getFont():getHeight())
    
  end;
  
  drawLobbyList = function(self,x,y)
    love.graphics.setColor(WHITE)
    local i = 0
    for id, lobby in pairs(self.lobbyList) do
      love.graphics.print(lobby, x, y+i*love.graphics.getFont():getHeight())
      i = i + 1
    end
    
    love.graphics.setColor(WHITE)
    love.graphics.rectangle("line", x, y, SW/4, SH/2)
    love.graphics.setColor(WHITE)
    love.graphics.print("Live Lobbies:", x, y-love.graphics.getFont():getHeight())
  end;
  }