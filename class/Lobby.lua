Lobby = Class{
  init = function(self, lobbyIndex, lobbyName, lobbyCreator)
    self.lobbyIndex = lobbyIndex
    self.lobbyName = lobbyName
    self.lobbyCreator = lobbyCreator
    self.board = Board()
    self.players = {}
    self.currentPlayer = nil
    
  end;
  
  update = function(self, dt)
    
  end;
  
  draw = function(self)
    
  end;
  
  
}
