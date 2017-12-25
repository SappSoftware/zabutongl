menu_list_test = {}

local playerList = {}

function menu_list_test:init()
  playerList = MenuList(600, 300, SW/4, SH/2, "Player's Online:", false)
end

function menu_list_test:fillPlayerList()
  playerList:addItem(lst_Player("Samuel"))
  playerList:addItem(lst_Player("Harrison"))
  playerList:addItem(lst_Player("Timothy"))
  playerList:addItem(lst_Player("Bayleigh"))
end

function menu_list_test