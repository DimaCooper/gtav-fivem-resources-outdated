Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		if IsControlJustPressed(1, 186) then
			TriggerEvent('pv:setCruiseSpeed')
		end
	end
end)

local cruise = 0

AddEventHandler('pv:setCruiseSpeed', function()
	if cruise == 0 and IsPedInAnyVehicle(GetPlayerPed(-1), false) then
		if GetEntitySpeedVector(GetVehiclePedIsIn(GetPlayerPed(-1), false), true)['x'] > 0 then
			cruise = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false))
			local cruiseKm = math.floor(cruise * 3.6 + 0.5)
			local cruiseMph = math.floor(cruise * 2.23694 + 0.5)
			
			NotificationMessage(" ~g~ Круиз вкл.~w~ - ~b~ " .. cruiseKm .." KPH")
			
			Citizen.CreateThread(function()
				while cruise > 0 and GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), -1) == GetPlayerPed(-1) do
					local cruiseVeh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
					if IsVehicleOnAllWheels(cruiseVeh) and GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) > (cruise - 2.0) then
						SetVehicleForwardSpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false), cruise)
					else
						cruise = 0
						NotificationMessage(" ~r~ Круиз выкл.")
						break
					end
					if IsControlPressed(1, 8) then
						cruise = 0
						NotificationMessage(" ~r~ Круиз выкл.")
					end
					if IsControlPressed(1, 32) then
						cruise = 0
						TriggerEvent('pv:setNewSpeed')
					end
					if cruise > 44 then
						cruise = 0
						NotificationMessage("")
						break
					end
					Wait(200)
				end
				cruise = 0
			end)
		else
			cruise = 0
			NotificationMessage("~r~Круиз выкл.")
		end
	else
		if cruise > 0 then
			NotificationMessage(" ~r~Круиз выкл.")
		end
		cruise = 0
	end
end)

AddEventHandler('pv:setNewSpeed', function()
	Citizen.CreateThread(function()
		while IsControlPressed(1, 32) do
			Wait(1)
		end
		TriggerEvent('pv:setCruiseSpeed')
	end)
end)

function NotificationMessage(message)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(message)
	DrawNotification(0,1)
end
