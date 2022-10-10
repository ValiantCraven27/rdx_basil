RDX = nil
TriggerEvent('rdx:getSharedObject', function(obj) RDX = obj end)

RegisterNetEvent("rdx:addbasil")
AddEventHandler("rdx:addbasil", function() 
local xPlayer = RDX.GetPlayerFromId(source)
local _amount1= math.random(1,2)
  xPlayer.addInventoryItem(Config.Item, _amount1)
end)
