local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")



vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","oxy_remat")

vRPcc = {}
Tunnel.bindInterface("oxy_remat",vRPcc)
Proxy.addInterface("oxy_remat",vRPcc)
vRPccC = Tunnel.getInterface("oxy_remat","oxy_remat")


AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
	vRPclient.addBlip(source,{-421.03393554688, -1710.8310546875, 19.439516067504, 68, 49, "Vehicle Crusher"})
end)

RegisterServerEvent("crushVehicle")
AddEventHandler("crushVehicle", function(vtype, vname, vehPrice)
    local user_id = vRP.getUserId({source})
src = source
    exports.oxmysql:execute("SELECT * FROM vrp_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle", {['@user_id'] = user_id, ['@vehicle'] = vname}, function (haveCar)
        if #haveCar > 0 then
            print(vname.."vname")
            print(vehPrice.."price")
                TriggerClientEvent("asd",src)
                local player = vRP.getUserSource({user_id})
                exports.oxmysql:execute("UPDATE vrp_user_vehicles SET user_id = @user_id WHERE user_id = @oldUser AND vehicle = @vehicle", {user_id = 2, oldUser = user_id, vehicle = vname}, function()end) 
                vRPclient.notify(player, {"~w~Ai primit ~r~$"..vehPrice.."~w~ pentru masina!"})
                vRP.giveMoney({user_id, vehPrice})
            else
                vRPclient.notify(player, {"~w~Nu deti aceasta masina!"})
            end
        end)
end)


RegisterServerEvent("entervw")
AddEventHandler("entervw", function()

    SetPlayerRoutingBucket(source,source)
end)
RegisterServerEvent("exitvw")
AddEventHandler("exitvw", function()

    SetPlayerRoutingBucket(source,0)
end)