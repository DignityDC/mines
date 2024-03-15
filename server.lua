RegisterServerEvent('detectMine')
AddEventHandler('detectMine', function(mineCoords, vehicleNetId)
    TriggerClientEvent('explodeMine', -1, mineCoords, vehicleNetId)
end)
