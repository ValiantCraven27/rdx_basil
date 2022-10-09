RDX  = nil
Citizen.CreateThread(function()
	while RDX == nil do
		TriggerEvent('rdx:getSharedObject', function(obj) RDX = obj end)
		Citizen.Wait(100)
	end
  end)

local CollectbasilPrompt
local active = false
local eat = false
local amount = 0
local cooldown = 0
local oldbasil = {}
local checkbasil = 0
local basil

local basilgroup = GetRandomIntInRange(0, 0xffffff)
print('basilgroup: ' .. basilgroup)

 function Collectbasil()
    Citizen.CreateThread(function()
        local str = Config.Name
        local wait = 0
        CollectbasilPrompt = Citizen.InvokeNative(0x04F97DE45A519419)
        PromptSetControlAction(CollectbasilPrompt, 0xD9D0E1C0)
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(CollectbasilPrompt, str)
        PromptSetEnabled(CollectbasilPrompt, true)
        PromptSetVisible(CollectbasilPrompt, true)
        PromptSetHoldMode(CollectbasilPrompt, true)
        PromptSetGroup(CollectbasilPrompt, basilgroup)
        PromptRegisterEnd(CollectbasilPrompt)
    end)
  end


Citizen.CreateThread(function()
    Wait(2000)     
         Collectbasil()
     while true do
        Wait(1)
        local playerped = PlayerPedId()
        if checkbasil < GetGameTimer() and not IsPedOnMount(playerped) and not IsPedInAnyVehicle(playerped) and not eat and cooldown < 1 then
            basil = GetClosestbasil()
            checkbasil = GetGameTimer() + 500
        end
        if basil then
            if active == false then
                local basilGroupName  = CreateVarString(10, 'LITERAL_STRING', "basil")
                PromptSetActiveGroupThisFrame(basilgroup, basilGroupName)
            end
          
            if PromptHasHoldModeCompleted(CollectbasilPrompt) then             
                active = true
                oldbasil[tostring(basil)] = true
                gobasilCollect()
            end
            
       end      
     end   
end)

 function  gobasilCollect()
    local playerPed = PlayerPedId()
    RequestAnimDict("mech_pickup@plant@berries")
    while not HasAnimDictLoaded("mech_pickup@plant@berries") do
    Wait(100)
    end
    TaskPlayAnim(playerPed, "mech_pickup@plant@berries", "enter_lf", 8.0, -0.5, -1, 0, 0, true, 0, false, 0, false)
    Wait(800)
    TaskPlayAnim(playerPed, "mech_pickup@plant@berries", "base", 8.0, -0.5, -1, 0, 0, true, 0, false, 0, false)
    Wait(2300)
    TriggerServerEvent("rdx:addbasil")  
    active = false
    ClearPedTasks(playerPed)
 end


function GetClosestbasil()
    local playerped = PlayerPedId()
    local itemSet = CreateItemset(true)
    local size = Citizen.InvokeNative(0x59B57C4B06531E1E, GetEntityCoords(playerped), 2.0, itemSet, 3, Citizen.ResultAsInteger())
    if size > 0 then
        for index = 0, size - 1 do
            local entity = GetIndexedItemInItemset(index, itemSet)
            local model_hash = GetEntityModel(entity)
            if model_hash == Config.Model and not oldbasil[tostring(entity)] then
              if IsItemsetValid(itemSet) then
                  DestroyItemset(itemSet)
              end
              return entity
            end
        end
    else
    end

    if IsItemsetValid(itemSet) then
        DestroyItemset(itemSet)
    end
end

function DisplayTxt(text, s1, s2, x, y, r, g, b, font)
    SetTextScale(s1, s2)
    SetTextColor(r, g, b, 255)--r,g,b,a
    SetTextCentre(true)--true,false
    SetTextDropshadow(1, 0, 0, 0, 200)--distance,r,g,b,a
    SetTextFontForCurrentCommand(font)
    DisplayText(CreateVarString(10, "LITERAL_STRING", text), x, y)
end

--[[
-794961754 -- ?? plant
-996392903  --- ??? plant
186402395 -- empty spot
-25286494
482937074
-1707502213
]]