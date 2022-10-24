local function deleteVehicle(veh)
    local delVeh = DeleteEntity(veh)
    return delVeh
end

local function sendChatMessage(src, prefix, msg, choosenColor)
    TriggerClientEvent("chat:addMessage", src, {
        args = {
            prefix,
            msg
        },
        color = choosenColor
    })
end

RegisterServerEvent("txp_vehicles:deletevehicle")
AddEventHandler("txp_vehicles:deletevehicle", function(clientVeh)
    veh = NetworkGetEntityFromNetworkId(clientVeh)
    deleteVehicle(veh)
end)

RegisterCommand("delveh", function(src)
    local player = GetPlayerPed(src)
    local veh = GetVehiclePedIsIn(player, false)
    if veh == 0 then
        sendChatMessage(src, "[ERROR]", "You are not in a vehicle!", {255, 0, 0})
    else
        deleteVehicle(veh)
    end
end, true)

RegisterCommand("repair", function(src)
    local player = GetPlayerPed(src)
    local veh = GetVehiclePedIsIn(player, false)
    if veh == 0 then
        sendChatMessage(src, "[ERROR]", "You are not in a vehicle!", {255, 0, 0})
    else
        vehNetId = NetworkGetNetworkIdFromEntity(veh)
        TriggerClientEvent("txp_vehicles:repairvehicle", -1, vehNetId)
    end
end, true)

RegisterCommand("veh", function(src, args)
    if #args == 0 then
        sendChatMessage(src, "[ERROR]", "Missing arguments", {255, 0, 0})
    elseif #args > 1 then
        sendChatMessage(src, "[ERROR]", "Too many arguments!", {255, 0, 0})
    else
        TriggerClientEvent("txp_vehicles:appearvehicle", src, args[1])
    end
end, true)

RegisterCommand("wash", function(src)
    local player = GetPlayerPed(src)
    local veh = GetVehiclePedIsIn(player, false)
    if veh == 0 then
        sendChatMessage(src, "[ERROR]", "You are not in a vehicle!", {255, 0, 0})
    else
        vehNetId = NetworkGetNetworkIdFromEntity(veh)
        TriggerClientEvent("txp_vehicles:washvehicle", -1, vehNetId)
    end
end, true)
