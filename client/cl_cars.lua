local function deleteVehicle(veh)
    local delVeh = DeleteEntity(veh)
    SetEntityAsNoLongerNeeded(delVeh)
    return delVeh
end

local function isPlayerInVehicle(player)
    local veh = GetVehiclePedIsIn(player, false)
    if IsPedInVehicle(player, veh, false) then
        return true
    end
    return false
end

local function loadModel(model)
    local hash = GetHashKey(model)
    if not IsModelInCdimage(hash) then
        return 0
    end
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        RequestModel(hash)
        Wait(250)
    end
    return hash
end

local function repairVehicle(veh)
    SetVehicleFixed(veh)
    SetVehicleEngineHealth(veh, 1000.0)
end

local function spawnVehicle(hash)
    local player = GetPlayerPed(-1)
    local x, y, z = table.unpack(GetEntityCoords(player))
    local w = GetEntityHeading(player)
    if isPlayerInVehicle(player) then
        local veh = GetVehiclePedIsIn(player, false)
        deleteVehicle(veh)
    end
    local veh = CreateVehicle(hash, x, y, z, w, true, true)
    SetEntityAsMissionEntity(veh, true, true)
    SetRadioToStationName("OFF")
    SetPedIntoVehicle(player, veh, -1)
    SetModelAsNoLongerNeeded(hash)
    return veh
end

local function washVehicle(veh)
    SetVehicleDirtLevel(veh, 0.0)
end

RegisterNetEvent("txp_vehicles:appearvehicle")
AddEventHandler("txp_vehicles:appearvehicle", function(model)
    hash = loadModel(model)
    if not hash then
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = false,
            args = {"[ERROR]", "Invalid model!"}
        })
    else
        spawnVehicle(hash)
    end
end)

RegisterNetEvent("txp_vehicles:deletevehicle")
AddEventHandler("txp_vehicles:deletevehicle", function()
    local player = GetPlayerPed(-1)
    if not isPlayerInVehicle(player) then
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = false,
            args = {"[ERROR]", "You are not in a vehicle!"}
        })
    else
        local veh = GetVehiclePedIsIn(player, false)
        deleteVehicle(veh)
    end
end)

RegisterNetEvent("txp_vehicles:repairvehicle")
AddEventHandler("txp_vehicles:repairvehicle", function()
    local player = GetPlayerPed(-1)
    if not isPlayerInVehicle(player) then
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = false,
            args = {"[ERROR]", "You are not in a vehicle!"}
        })
    else
        local veh = GetVehiclePedIsIn(player, false)
        repairVehicle(veh)
    end
end)

RegisterNetEvent("txp_vehicles:repairvehicle")
AddEventHandler("txp_vehicles:repairvehicle", function()
    local player = GetPlayerPed(-1)
    if not isPlayerInVehicle(player) then
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = false,
            args = {"[ERROR]", "You are not in a vehicle!"}
        })
    else
        local veh = GetVehiclePedIsIn(player, false)
        washVehicle(veh)
    end
end)

TriggerEvent("chat:addSuggestion", "/delveh", "Delete vehicle command.", nil)
TriggerEvent("chat:addSuggestion", "/repair", "Repair vehicle command.", nil)
TriggerEvent("chat:addSuggestion", "/veh", "Vehicle spawn command.", {{ name="<model>", help="vehicle model"}})
TriggerEvent("chat:addSuggestion", "/wash", "Wash vehicle command.", nil)
