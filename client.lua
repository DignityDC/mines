RegisterNetEvent('explodeMine')
AddEventHandler('explodeMine', function(mineCoords)
    AddExplosion(mineCoords.x, mineCoords.y, mineCoords.z, 40, 10.0, true, false, 2.0)
end)

local explodedMines = {}

local function IsVehicleNearMine(vehicle, mineHashes)
    local vehiclePos = GetEntityCoords(vehicle)
    for _, mineHash in ipairs(mineHashes) do
        local mine = GetClosestObjectOfType(vehiclePos, Config.DetectionRadius, mineHash, false, false, false)
        if mine and DoesEntityExist(mine) and not explodedMines[mine] then
            explodedMines[mine] = true 
            local mineCoords = GetEntityCoords(mine)
            TriggerServerEvent('detectMine', mineCoords, NetworkGetNetworkIdFromEntity(vehicle))
            return true
        end
    end
    return false
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)

        local playerPed = PlayerPedId()
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local vehicleModel = GetEntityModel(vehicle)
            local vehicleName = GetDisplayNameFromVehicleModel(vehicleModel):lower()

            for _, vName in ipairs(Config.Vehicles) do
                if vName == vehicleName then
                    local mineHashes = {}
                    for _, mine in ipairs(Config.Mines) do
                        table.insert(mineHashes, mine.hash)
                    end
                    
                    if IsVehicleNearMine(vehicle, mineHashes) then
                        SetVehicleEngineHealth(vehicle, -4000)
                        SetVehiclePetrolTankHealth(vehicle, -4000)
                        NetworkExplodeVehicle(vehicle)
                        break
                    end
                end
            end
        end
    end
end)
