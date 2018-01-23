local floor = math.floor
ServerObject = Class{
  init = function(self, ip, port, playerListData)
    self.tickRate = 1/60
    self.tick = 0
    self.sender = Sock.newServer(ip, port)
    self.sender:setSerialization(Bitser.dumps, Bitser.loads)
    self:setCallbacks()
    self.playerList = {}
    self.fullPlayerList = playerListData
    self.activeZone = Zone(1)
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
    
    self.sender:on("connect", function(data, client)
      
    end)
    
    self.sender:on("disconnect", function(data, client)
      local index = client:getIndex()
      if data == 1 then
        self.activeZone:removePlayer(index)
        self.playerList[index] = nil
      end
    end)
    
    self.sender:on("register", function(data, client)
      local index = client:getIndex()
      local username_available = true
      for i, user_data in pairs(self.fullPlayerList) do
        if data.username == user_data.username then
          username_available = false
          break
        end
      end
      if username_available == true then
        table.insert(self.fullPlayerList, {username = data.username, password = data.password})
        table.insert(self.playerList, index, data.username)
        self:updatePlayerFile()
      end
        
      client:send("register", username_available)
    end)
    
    self.sender:on("login", function(data, client)
      local index = client:getIndex()
      local success = false
      for i, user_data in pairs(self.fullPlayerList) do
        if data.username == user_data.username and data.password == user_data.password then
          success = true
          table.insert(self.playerList, index, data.username)
          break
        end
      end
      client:send("login", success)
    end)
    
    self.sender:on("joinZone", function(data, client)
      local index = client:getIndex()
      local player_id = data
      self.activeZone:addPlayer(Player(player_id), index)
      client:send("joinZone", self.activeZone.zone_id)
    end)
    
    self.sender:on("updatePlayer", function(data, client)
      local index = client:getIndex()
      self.activeZone:updatePlayer(data, index)
    end)
  end;
  
  update = function(self, dt)
    self.tick = self.tick + dt
    
    if self.tick >= self.tickRate then
      self.sender:update(self.tick)
      self.tick = 0
    end
  end;
  
  draw = function(self)
    love.graphics.print(self.sender:getSocketAddress(), 5, 5)
    love.graphics.printf("Server Running!", SW/2-100, floor(SH/4), 200, "center", 0, 1, 1, 0, love.graphics.getFont():getHeight()/2)
    
    self:drawPlayerList(600, 300)
  end;
  
  drawPlayerList = function(self,x,y)
    love.graphics.setColor(CLR.WHITE)
    local i = 0
    for id, player in pairs(self.playerList) do
      love.graphics.print(player, x, y+i*love.graphics.getFont():getHeight())
    end
    
    love.graphics.setColor(CLR.WHITE)
    love.graphics.rectangle("line", x, y, SW/4, SH/2)
    love.graphics.setColor(CLR.WHITE)
    love.graphics.print("Players Online:", x, y-love.graphics.getFont():getHeight())
    
  end;
  
  updatePlayerFile = function(self)
    love.filesystem.write("player_list.lua", Tserial.pack(self.fullPlayerList))
  end;

}