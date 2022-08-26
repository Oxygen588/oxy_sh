local display = false
local trecut = false
local cam1 = nil
local cam = nil
local gameplaycam = nil
incarcrusher = false
vRP = Proxy.getInterface("vRP")
vRPserver = Tunnel.getInterface("vRP","oxy_remat")
vRPccS = Tunnel.getInterface("oxy_remat","oxy_remat")

local x, y, z =-43.605812072754,-1105.4084472656,27.209280014038

vehiclePrice = 0
vehicleName = ""
vehModel = ""
vtypes = ""
incircle = false
incircle2 = false
crusherBlip = nil
cevaVariabila = false

function crusher_drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end

function DrawText3D(x,y,z, text, scl, font) 

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*scl
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 1.1*scale)
        SetTextFont(font)
        SetTextProportional(1)
        -- SetTextScale(0.0, 0.55)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

function createRematBlip(x, y, z)
	if (crusherBlip == nil) then
		vRP.setNamedBlip({"Crusher", x, y, z, 380, 49, "Crusher"})
		crusherBlip = true
	end
end
local function f(n)
	return (n + 0.00001)
end
local function LocalPed()
	return GetPlayerPed(-1)
end
local function EndFade()
	Citizen.CreateThread(function()
		ShutdownLoadingScreen()

        DoScreenFadeIn(500)

        while IsScreenFadingIn() do
            Citizen.Wait(0)
        end
	end)
end


function job_DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
Citizen.CreateThread(function()
	Wait(200)
	
	while true do
		
		tick = 500
		local pos = GetEntityCoords(GetPlayerPed(-1), true)
		local ped = GetPlayerPed(-1)

		if(GetDistanceBetweenCoords(pos.x, pos.y, pos.z, x, y, z) < 40.0)then
			tick = 0

			DrawText3D(x,y,z+0.3, "~w~Catalog Auto", 2.0, 1)
			DrawMarker(36, x, y, z-0.5, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 8, 104, 40, 255, true, 0, 0, true)
			if(GetDistanceBetweenCoords(pos.x, pos.y, pos.z, x, y, z) < 2)then
	
				
							job_DisplayHelpText("Apasa E pentru a deschide catalog-ul auto!")
							if IsControlJustPressed(0, 38)  then
								
								SetDisplay(true)
							end
			end
		end
		Citizen.Wait(tick)
	end
end)











Positions = {
	[1] = {-2160.6833496094,-396.16622924805,13.366439819336,60.962993621826},
	[2] = {-2160.046875,-393.20867919922,13.345651626587,60.962993621826},
	[3] = {-2159.5483398438,-390.2880859375,13.308574676514,60.962993621826},
	[4] = {-2159.046875,-387.21661376953,13.269671440125,60.962993621826},
	[5] = {-2158.1967773438,-384.17535400391,13.230498313904,60.962993621826},
	[6] = {-2157.6965332031,-381.36590576172,13.195074081421,60.962993621826}
}





function showroom_drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
	    SetTextOutline()
	end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end


testDriveCar = nil
testDriveSeconds = 60
isInTestDrive = false
isInCar = false

RegisterNUICallback(
    "TestDriveCallback",
    function(data, cb)
		DoScreenFadeOut(1000)
        Wait(2000)
        EndFade()
									while not HasModelLoaded(data.modelcar) do
										RequestModel(data.modelcar)
										Citizen.Wait(10)
										showroom_drawTxt(0.935, 0.575, 1.0,1.0,0.4, "~r~LOADING VEHICLE TEXTURE", 255, 255, 255, 255)
									end
									if HasModelLoaded(data.modelcar) then
										testDriveCar = CreateVehicle(data.modelcar,-914.83026123046,-3287.1538085938,13.521618843078,60.962993621826,false,false)
										SetModelAsNoLongerNeeded(data.modelcar)
										TaskWarpPedIntoVehicle(GetPlayerPed(-1),testDriveCar,-1)
										--vRP.notify({"~g~You have ~r~1 Minute~g~ to test drive this vehicle!"})
										for i = 0,24 do
											SetVehicleModKit(testDriveCar,0)
											RemoveVehicleMod(testDriveCar,i)
										end
										if(testDriveCar)then
											SetEntityVisible(GetPlayerPed(-1),true)
											FreezeEntityPosition(GetPlayerPed(-1),false)
										
										end
                                    end
							
									SetDisplay(false)
            end)
vcar = ""
RegisterNUICallback(
	"vezimasina",
		function(data, cb)
			TriggerServerEvent("entervw")
			SetDisplay(false)
			invw = true
			
			while not HasModelLoaded(data.modelcar) do
				RequestModel(data.modelcar)
				Citizen.Wait(10)
				showroom_drawTxt(0.935, 0.575, 1.0,1.0,0.4, "~r~LOADING VEHICLE TEXTURE", 255, 255, 255, 255)
			end
				
			DoScreenFadeOut(1000)
        Wait(2000)
        EndFade()
			if HasModelLoaded(data.modelcar) then
				vcar = CreateVehicle(data.modelcar,-2160.5422363281,-399.25399780273,13.381350517273,257.962993621826,false,false)
				SetModelAsNoLongerNeeded(data.modelcar)
				SetEntityCoords(GetPlayerPed(-1),-2153.6169433594,-401.96615600586,13.372273445129)							
				for i = 0,24 do
					SetVehicleModKit(vcar,0)
					RemoveVehicleMod(vcar,i)
				end
				if(vcar)then
					SetEntityVisible(GetPlayerPed(-1),true)
					SetVehicleLights(vcar,2)
				end
			end
			odors = false
		
			while invw do
				Wait(0)
				SetVehicleUndriveable(vcar,true)
				if odors then
					showroom_drawTxt(0.935, 1.375, 1.0,1.0,0.4, "~r~[G] - ~w~Inchide Usile ~r~[H] - ~w~Iesi", 255, 255, 255, 255)
				else
					showroom_drawTxt(0.935, 1.375, 1.0,1.0,0.4, "~r~[G] - ~w~Deschide Usile  ~r~[H] - ~w~Iesi", 255, 255, 255, 255)
				end
					DrawText3D(-2160.5422363281,-399.25399780273,13.381350517273 + 0.5, data.nume.."\n"..data.pret.."$", 1.0)
				if IsControlJustPressed(0,47) then
					odors = not odors
												for k=-1,10 do
							if odors then
								SetVehicleDoorOpen(vcar,k,false,false)
							else
								SetVehicleDoorShut(vcar,k,true,false)
							end
						end
						Wait(500)
						
				end
				if IsControlJustPressed(0,74) then
					DoScreenFadeOut(1000)
					Wait(1000)
					Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vcar))
					SetEntityCoords(GetPlayerPed(-1),-39.77363204956,-1110.4862060546,26.438457489014)
					TriggerServerEvent("exitvw")
					Wait(2000)
					EndFade()
					
					invw = false
				end
			end	
end)
--[5]: {data:{},nume:"M3 32055d",brand:"BMW",hp:400,topspeed:200,model:"t20",tipfrane:"bune",pret:50000,expt:"tractare"}
RegisterNUICallback(
	"viewallvehs",
		function(data, cb)
			TriggerServerEvent("entervw")
			SetDisplay(false)
			print(data.brand)
			DoScreenFadeOut(1000)
        Wait(2000)
        EndFade()
			data.vehs = json.decode(data.vehs)
			for k,v in pairs(data.vehs) do
				print(v.nume)
			end
	invw = true
	cat = 1
	SetEntityCoords(GetPlayerPed(-1),-2153.6169433594,-401.96615600586,13.372273445129)	

	vehslist = {}
	while invw do
		Wait(0)
		found = false
		usi = false
		unloadedvehs = "\n"
		for k,v in pairs(data.vehs) do
			if v.brand == data.brand then
 				if data.vehs[k].data.vehicle == nil then
					if not HasModelLoaded(data.vehs[k].model) then
						RequestModel(data.vehs[k].model)
						unloadedvehs = unloadedvehs..data.vehs[k].nume.."\n"
					end
						
					
					if HasModelLoaded(data.vehs[k].model) then
				
						data.vehs[k].data.vehicle = CreateVehicle(data.vehs[k].model,Positions[cat][1],Positions[cat][2],Positions[cat][3],Positions[cat][4],false,false)
						SetVehicleEngineOn(data.vehs[k].data.vehicle,true,true,false)
						SetModelAsNoLongerNeeded(data.vehs[k].model)
						table.insert(vehslist,data.vehs[k].data.vehicle)
						for i = 0,24 do
							SetVehicleModKit(data.vehs[k].data.vehicle,0)
							RemoveVehicleMod(data.vehs[k].data.vehicle,i)
						end
						if(data.vehs[k].data.vehicle)then
							SetEntityVisible(GetPlayerPed(-1),true)
							SetVehicleLights(data.vehs[k].data.vehicle,2)
						end
						cat = cat + 1
					end
				else
					local pos = GetEntityCoords(GetPlayerPed(-1), true)
					local posv = GetEntityCoords(data.vehs[k].data.vehicle, true)
					DrawText3D(posv.x, posv.y, posv.z+ 0.5, data.vehs[k].nume.."\n"..data.vehs[k].pret.."$", 1.0)
				
					if(GetDistanceBetweenCoords(pos.x, pos.y, pos.z, posv.x, posv.y, posv.z) < 3)then
						SetVehicleCurrentRpm(data.vehs[k].data.vehicle,1.0)
						if IsControlJustPressed(0,47) then
							if data.vehs[k].data.odors == nil then
								data.vehs[k].data.odors = false
							end
							data.vehs[k].data.odors = not data.vehs[k].data.odors
								for k1=-1,10 do
									if data.vehs[k].data.odors then
										SetVehicleDoorOpen(data.vehs[k].data.vehicle,k1,false,false)
									else
										SetVehicleDoorShut(data.vehs[k].data.vehicle,k1,true,false)
									end
								end
								Wait(500)
								
						end
						if data.vehs[k].data.odors == nil then
							data.vehs[k].data.odors = false
						end
						found = true
						if(GetDistanceBetweenCoords(pos.x, pos.y, pos.z, posv.x, posv.y, posv.z) < 1)then
							SetVehicleUndriveable(data.vehs[k].data.vehicle,true)
						else
							SetVehicleUndriveable(data.vehs[k].data.vehicle,false)
							SetVehicleLights(data.vehs[k].data.vehicle,2)
							SetVehicleEngineOn(data.vehs[k].data.vehicle,true,true,false)
						end
						if data.vehs[k].data.odors then
							usi = true
						end
					end
				end
			end
		end
		if #unloadedvehs> 4 then
			showroom_drawTxt(1.235, 1.375, 1.0,1.0,0.4, "~r~Vehicule care inca se incarca:"..unloadedvehs, 255, 255, 255, 255)
		end
		--SetVehicleUndriveable(vcar,true)
		if found == true then
			if usi then
				showroom_drawTxt(0.935, 1.375, 1.0,1.0,0.4, "~r~[G] - ~w~Inchide Usile ~r~[H] - ~w~Iesi", 255, 255, 255, 255)
			else
				showroom_drawTxt(0.935, 1.375, 1.0,1.0,0.4, "~r~[G] - ~w~Deschide Usile  ~r~[H] - ~w~Iesi", 255, 255, 255, 255)
			end
		end
		if found == false then
			showroom_drawTxt(0.935, 1.375, 1.0,1.0,0.4, "~r~[H] - ~w~Iesi", 255, 255, 255, 255)
		end
		
		if IsControlJustPressed(0,74) then
			DoScreenFadeOut(1000)
					Wait(1000)
					
			for k,v in pairs(vehslist) do
				Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(v))
				SetEntityCoords(GetPlayerPed(-1),-39.77363204956,-1110.4862060546,26.438457489014)
			end
			TriggerServerEvent("exitvw")
			Wait(2000)
					EndFade()
				invw = false
		end
	end	
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if(testDriveSeconds < 60)then
			showroom_drawTxt(1.30, 1.40, 1.0,1.0,0.35, "~g~TestDrive: ~r~"..testDriveSeconds.." ~y~Seconds", 255, 255, 255, 255)
		end
		if(isInTestDrive) then
			if(isInCar == false)then
				destroyTestDriveCar()
			end
		end
	end
end)
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1100)
		if(testDriveCar ~= nil) and (isInTestDrive == false) then
			isInTestDrive = true
		else
			isInTestDrive = false
		end
		if(testDriveCar ~= nil)then
			local IsInVehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
			if(IsInVehicle ~= nil)then
				if(testDriveCar == IsInVehicle)then
					if(testDriveSeconds > 0)then
						testDriveSeconds = testDriveSeconds - 1
					else
						destroyTestDriveCar()
					end
					isInCar = true
				else
					isInCar = false
				end
			end
		end
	end
end)

function destroyTestDriveCar()
	if(testDriveCar ~= nil)then
		if(DoesEntityExist(testDriveCar))then
			Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(testDriveCar))
		end
		testDriveCar = nil
		isInTestDrive = false
	end
	testDriveSeconds = 60
    SetEntityCoords(GetPlayerPed(-1),-39.77363204956,-1110.4862060546,26.438457489014)
	---vRP.teleport({-39.77363204956,-1110.4862060546,26.438457489014})
	SetEntityHeading(GetPlayerPed(-1), 180.0)
	--vRP.notify({"~r~The test drive is over!"})
end







































function DrawText3D(x, y, z, text, scl)

    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)

    local scale = (1 / dist) * scl
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov

    if onScreen then
        SetTextScale(0.0 * scale, 1.1 * scale)
        SetTextFont(0)
        SetTextProportional(1)
        -- SetTextScale(0.0, 0.55)
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






--very important cb 
RegisterNUICallback("exit", function(data)
	
	TriggerEvent("iesi")
    SetDisplay(false)
end)


RegisterNUICallback("vinde", function(data)
	TriggerServerEvent("crushVehicle",vtypes,vehModel,vehiclePrice)
	TriggerEvent("iesic")
    SetDisplay(false)
end)

-- this cb is used as the main route to transfer data back 
-- and also where we hanld the data sent from js
RegisterNUICallback("main", function(data)
    chat(data.text, {0,255,0})
    SetDisplay(false)
end)

RegisterNUICallback("error", function(data)
    chat(data.error, {255,0,0})
    SetDisplay(false)
end)

function SetDisplay(bool, masina1,pret1,prettt)
    display = bool
    SetNuiFocus(bool, bool)
	if bool then
		ExecuteCommand("e book")
	else
		ExecuteCommand("e c")
	end
	Wait(1500)
    SendNUIMessage({
        type = "ui",
        status = bool,
        masini = masina1,
        pret = pret1,
		pretoriginal = prettt,
		numemasina = vehicleName,
    })

end









