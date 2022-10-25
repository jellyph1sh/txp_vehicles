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
    local currentVeh = GetVehiclePedIsIn(player, false)
    if currentVeh ~= 0 then
        vehNetId = NetworkGetNetworkIdFromEntity(currentVeh)
        if NetworkDoesNetworkIdExist(vehNetId) then
            TriggerServerEvent("txp_vehicles:deletevehicle", vehNetId)
            while GetVehiclePedIsIn(player, false) == currentVeh do
                Wait(5)
            end
        else
            TriggerEvent("chat:addMessage", {
                color = {255, 0, 0},
                multiline = false,
                args = {"[ERROR]", "Invalid network id!"}
            })
        end
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
    if hash == 0 then
        TriggerEvent("chat:addMessage", {
            color = {255, 0, 0},
            multiline = false,
            args = {"[ERROR]", "Invalid model!"}
        })
    else
        spawnVehicle(hash)
    end
end)

RegisterNetEvent("txp_vehicles:repairvehicle")
AddEventHandler("txp_vehicles:repairvehicle", function(svVeh)
    veh = NetworkGetEntityFromNetworkId(svVeh)
    repairVehicle(veh)
end)

RegisterNetEvent("txp_vehicles:washvehicle")
AddEventHandler("txp_vehicles:washvehicle", function(svVeh)
    veh = NetworkGetEntityFromNetworkId(svVeh)
    washVehicle(veh)
end)

TriggerEvent("chat:addSuggestion", "/delveh", "Delete vehicle command.", nil)
TriggerEvent("chat:addSuggestion", "/repair", "Repair vehicle command.", nil)
TriggerEvent("chat:addSuggestion", "/veh", "Vehicle spawn command.", {{ name="model", help="vehicle model"}})
TriggerEvent("chat:addSuggestion", "/wash", "Wash vehicle command.", nil)
