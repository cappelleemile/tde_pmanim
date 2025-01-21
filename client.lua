local isMenuOpen = false
local heeftTelefoonVast = false
local telefoonModel = "prop_npc_phone_02"
local animDict = "cellphone@"
local animName = "cellphone_text_read_base"
local phone_net = nil

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if IsPauseMenuActive() and not isMenuOpen then
            SetCurrentPedWeapon(GetPlayerPed(-1), 0xA2719263, true)
            TriggerEvent("tde_pmanim:ToggleAnimation")
            isMenuOpen = true
        elseif not IsPauseMenuActive() and isMenuOpen then
            Wait(500)
            TriggerEvent("tde_pmanim:ToggleAnimation")
            isMenuOpen = false
        end
    end
end)

RegisterNetEvent("tde_pmanim:ToggleAnimation")
AddEventHandler("tde_pmanim:ToggleAnimation", function()
    if not heeftTelefoonVast then
        RequestModel(GetHashKey(telefoonModel))
        while not HasModelLoaded(GetHashKey(telefoonModel)) do
            Citizen.Wait(100)
        end

        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Citizen.Wait(100)
        end

        local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
        local mapspawned = CreateObject(GetHashKey(telefoonModel), plyCoords.x, plyCoords.y, plyCoords.z, true, true, true)
        local netid = ObjToNet(mapspawned)
        SetNetworkIdExistsOnAllMachines(netid, true)
        NetworkSetNetworkIdDynamic(netid, true)
        SetNetworkIdCanMigrate(netid, false)
        AttachEntityToEntity(mapspawned, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 0, true)
        TaskPlayAnim(GetPlayerPed(PlayerId()), animDict, animName, 1.0, 1.0, -1, 49, 0, false, false, false)
        phone_net = netid
        heeftTelefoonVast = true
    else
        ClearPedSecondaryTask(GetPlayerPed(PlayerId()))
        DetachEntity(NetToObj(phone_net), true, true)
        DeleteEntity(NetToObj(phone_net))
        phone_net = nil
        heeftTelefoonVast = false
    end
end)
