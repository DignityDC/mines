RegisterServerEvent('detectMine')
AddEventHandler('detectMine', function(mineCoords, vehicleNetId)
    TriggerClientEvent('explodeMine', -1, mineCoords, vehicleNetId)
end)


RegisterServerEvent('logMineExplosion')
AddEventHandler('logMineExplosion', function(playerServerId, vehicleName, mineHash, mineCoords)
    if Config.Logs then
        local playerName = GetPlayerName(playerServerId) or "Unknown Player"
        local discordInfo = {
            ["color"] = 15158332,
            ["type"] = "rich",
            ["title"] = "Mine Explosion Detected",
            ["description"] = string.format("Player `%s` (%s) triggered mine `%s` with vehicle `%s` at coordinates [X: %.2f, Y: %.2f, Z: %.2f].", playerName, playerServerId, mineHash, vehicleName, mineCoords.x, mineCoords.y, mineCoords.z),
            ["footer"] = {
                ["text"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }
        }

        PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({embeds = {discordInfo}}), {['Content-Type'] = 'application/json'})
    end
end)
