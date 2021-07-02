--local variables
local PedID = GetPlayerPed(-1)
local distance_until_text_disappears = 5000

_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Vehicle Spawner", "Select your vehicle", nil, nil, nil, nil, nil, 0, 0, 0, 210)
_menuPool:Add(mainMenu)

--local arrays
vehicleGarage = {
    marker = 25, -- Skinny Circle
    submarker = {
        marker = 36, --Car Icon
        posz = 34.00,
    },
    scale = 6.0,
    x = -2141.19,
    y = 3248.02,
    z = 31.90,
    colour = {0,71,100,180}
}

--Functions
function spawnVehicle(carName)
    local car = GetHashKey(carName)

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(1)
    end

    local vehicle = CreateVehicle(car, vehicleGarage.x, vehicleGarage.y, vehicleGarage.z, 190.0, true, false)
    TaskWarpPedIntoVehicle(PedID, vehicle, -1)
end

function Draw3DText(x, y, z, scl_factor, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov * scl_factor
    if onScreen then
        SetTextScale(0.0, scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

--Functions End

-- Vehicle Spawner Start
function vehicleMenu(menu)
    local landVehicles = _menuPool:AddSubMenu(menu, "Land Vehicles")
    local airVehicles = _menuPool:AddSubMenu(menu, "Air Vehicles")

    menu:AddItem(landVehicles)
        local barracks = NativeUI.CreateItem("Barracks","Infantry Transport Truck")
        local barracks2 = NativeUI.CreateItem("Barracks Cab","Truck Cab, Ideal for adding a Trailer")
        local crusader = NativeUI.CreateItem("Crusader","4x4 Car, for ~r~four~w~ soldiers")
        local rhino = NativeUI.CreateItem("Rhino","Tank. Need we say more?")
    --local dinghy2 = NativeUI.CreateItem("Dinghy")
        landVehicles:AddItem(barracks)
        landVehicles:AddItem(barracks2)
        landVehicles:AddItem(crusader)
        landVehicles:AddItem(rhino)

    menu:AddItem(airVehicles)
        local cargobob = NativeUI.CreateItem("Cargobob","Dual Rotor Helicopter")
        local titan = NativeUI.CreateItem("Titan","Cargo Plane (C130J)")
        local buzzard = NativeUI.CreateItem("Buzzard","Little Bird Helicopter")

        airVehicles:AddItem(cargobob)
        airVehicles:AddItem(titan)
        airVehicles:AddItem(buzzard)

    landVehicles.OnItemSelect = function(sender, item, index)
        if item == barracks then
            spawnVehicle("barracks")
            _menuPool:CloseAllMenus()
        elseif item == barracks2 then
            spawnVehicle("barracks2")
            _menuPool:CloseAllMenus()
        elseif item == crusader then
            spawnVehicle("crusader")
            _menuPool:CloseAllMenus()
        elseif item == rhino then
            spawnVehicle("rhino")
            _menuPool:CloseAllMenus()
        end
    end

    airVehicles.OnItemSelect = function(sender, item, index)
        if item == cargobob then
            spawnVehicle("cargobob")
            _menuPool:CloseAllMenus()
        elseif item == titan then
            spawnVehicle("titan")
            _menuPool:CloseAllMenus()
        elseif item == buzzard then
            spawnVehicle("buzzard")
            _menuPool:CloseAllMenus()
        end
    end
end
--Vehicle Spawner End

--Draw Marker and submarker, this also checks to make sure the player is within the marker to allow the menu to open
Citizen.CreateThread(
    function()
    
    local playerCoord = GetEntityCoords(PedID, false)
    local vehicleVector = vector3(vehicleGarage.x, vehicleGarage.y, vehicleGarage.z)

        while true do
            Citizen.Wait(1)
                DrawMarker(
                    vehicleGarage.marker,
                    vehicleGarage.x,
                    vehicleGarage.y,
                    vehicleGarage.z,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    vehicleGarage.scale,
                    vehicleGarage.scale,
                    vehicleGarage.scale,
                    vehicleGarage.colour[1],
                    vehicleGarage.colour[2],
                    vehicleGarage.colour[3],
                    vehicleGarage.colour[4],
                    false,
                    true,
                    2,
                    nil,
                    nil,
                    false
                )

                if vehicleGarage.submarker ~= nil then 
                    DrawMarker(
                     vehicleGarage.submarker.marker,
                     vehicleGarage.x,
                     vehicleGarage.y,
                     vehicleGarage.submarker.posz,
                     0.0,
                     0.0,
                     0.0,
                     0.0,
                     0.0,
                     0.0,
                     vehicleGarage.scale/2,
                     vehicleGarage.scale/2,
                     vehicleGarage.scale/2,
                     vehicleGarage.colour[1],
                     vehicleGarage.colour[2],
                     vehicleGarage.colour[3],
                     vehicleGarage.colour[4],
                     false,
                     true,
                     2,
                     nil,
                     nil,
                     false
                    )
                end



                local playerCoord = GetEntityCoords(PedID, false)
                local vehicleVector = vector3(vehicleGarage.x, vehicleGarage.y, vehicleGarage.z)

                if Vdist2(playerCoord, vehicleVector) < distance_until_text_disappears then
                    Draw3DText(vehicleGarage.x, vehicleGarage.y, vehicleGarage.z + 1, 1.0, "Press F2 to open the Spawner")
                end

                _menuPool:ProcessMenus()
                if IsControlJustPressed(0, 289) and GetDistanceBetweenCoords(playerCoord, vehicleVector) < 3.0 then -- F2 key to open the menu.
                    mainMenu:Visible(not mainMenu:Visible())
                end

                if _menuPool:IsAnyMenuOpen() and GetDistanceBetweenCoords(playerCoord, vehicleVector) >= 3.0 then
                    _menuPool:CloseAllMenus()
                end
                
        end
    end
)

--Draws a Blip on the Map for the VehicleGarage.
local blip = AddBlipForCoord(vehicleGarage.x, vehicleGarage.y, vehicleGarage.z, 100)

SetBlipSprite(blip, 357)
SetBlipDisplay(blip, 2)
SetBlipScale(blip, 0.9)
SetBlipAsFriendly(blip, true)
SetBlipColour(blip, 3)
BeginTextCommandSetBlipName("STRING")
AddTextComponentString("Vehicle Garage")
EndTextCommandSetBlipName(blip)

--NativeUI
vehicleMenu(mainMenu)
_menuPool:MouseControlsEnabled (false);
_menuPool:MouseEdgeEnabled (false);
_menuPool:ControlDisablingEnabled(false);
_menuPool:RefreshIndex()