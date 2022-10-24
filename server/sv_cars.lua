local function sendChatMessage(src, prefix, msg, choosenColor)
    TriggerClientEvent("chat:addMessage", src, {
        args = {
            prefix,
            msg
        },
        color = choosenColor
    })
end

RegisterCommand("veh", function(src, args)
    if #args == 0 then
        sendChatMessage(src, "[ERROR]", "Missing arguments", {255, 0, 0})
    elseif #args > 1 then
        sendChatMessage(src, "[ERROR]", "Too many arguments!", {255, 0, 0})
    else
        TriggerClientEvent("txp_vehicles:appearvehicle", src, args[1])
    end
end, true)

RegisterCommand("delveh", function(src)
    TriggerClientEvent("txp_vehicles:deletevehicle", src)
end, true)
