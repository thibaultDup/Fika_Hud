--Initialisation de l'objet ESX à nil
ESX = nil


--THREAD[1] - Récuperation de l'objet ESX --------------------------------------------------------------------------------------------
Citizen.CreateThread(function()

    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(100)
    end
	
end)
--Fin THREAD[1] --------------------------------------------------------------------------------------------


--EVENTS --------------------------------------------------------------------------------------------
--Event de récuperation des valeurs pour les stats : Sasiété et Hydratation
RegisterNetEvent("Fika_Hud:updateStatus")
AddEventHandler("Fika_Hud:updateStatus", function(status)
    TriggerEvent('esx_status:getStatus', 'hunger', function(status)
        food = status.val / 10000
	end)
	
    TriggerEvent('esx_status:getStatus', 'thirst', function(status)
        thirst = status.val / 10000
    end)
	
end)

--MODIFIED
--Event client call par le serveur pour pouvoir renvoyer la valeur du contenu du compte societé du côté serveur
RegisterNetEvent('Fika_Hud:GetSocietyAccount:Return')
AddEventHandler('Fika_Hud:GetSocietyAccount:Return', function(moneyC)
	moneyCompany = ESX.Math.GroupDigits(moneyC)
end)
-- fin EVENTS --------------------------------------------------------------------------------------------



--THREAD[2] looped principale --------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do 

		
		--Met en pause le thread pour une certaine durée (définie dans la config, en milisecondes)
		--Doit toujours se trouver en haut de ce THREAD, pour laisser le temps aux autres scripts dont l'on a besoin de chager (ex : es_extended)
		Citizen.Wait(Config['TickTime'])
		
		--Récupére l'id du joueur
		local playerId = PlayerPedId()
		--Test si le joueur se trouve dans un véhicule ou non
		local inVehicule = IsPedSittingInAnyVehicle(playerId)
		--Récupération de l'objet ESX PlayerData contenant les informations relatives au joueur
		local playerData = ESX.GetPlayerData()
		
		--Trigger l'event client qui permet de récuperer les valeurs des stats : Sasiété et Hydratation
		TriggerEvent("Fika_Hud:updateStatus")
		
		--Appel de l'event server permetant de récupérer la quantité d'argent présente sur le compte de la société auquel le joueur appartient
		TriggerServerEvent('Fika_Hud:GetSocietyAccount')
		
		
		--TODO:PRINT POUR COMPARER LA VALEUR DE [PlayerPedId] et la valeur de [PlayerPed]
		
		--Affiche la minimap si elle est activé dans le fichier config, sinon cache la minimap sauf lorsque le joueur se trouve dans un vehicule
        if (Config['HideMinimap']) then
            if inVehicule then
                DisplayRadar(true)
            else
                DisplayRadar(false)
            end
        else
            DisplayRadar(true)
        end
		
		--TODO:PRINT POUR COMPARER LA VALEUR DE [PlayerPedId] et la valeur de [PlayerPed] *2*
		
		--Attribue à playeridInput l'id du joueur si l'option est activée dans le fichier de config
		if (Config['PlayerID']) then
            localPlayerID = playerid -- ??? TODO: A COMPARER AVEC UNE VERSION ANTERIEUR DU CODE *1*
            playeridInput = GetPlayerServerId(NetworkGetEntityOwner(GetPlayerPed(-1)))
        else
            localPlayerID = false -- ???
        end
		
		
        --MODIFIED
		--Determine si le personnage est assis dans un véhicule ou non pour pouvoir modifier l'affichage dans le script.js
        local hudPosition
        if inVehicule then
            hudPosition = 'vehiculePos'
        end


		--Si l'affichage du Fuel est activé dans le fichier de conf, récuperation de la valeur du niveau de Fuel
        local fuelPosition
        local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
        if (Config['Fuel']) then
			if inVehicule then
				fuelPosition = 'right'
				fuelEvent = GetVehicleFuelLevel(playerVeh);
			else 
				localPlayerID = false -- ???
			end
		end
		
		
		--Recuperation et formatage de l'heure en jeu si l'affichage de l'horloge est activé dans le fichier de config
		if(Config['clock']) then
			clockHour = GetClockHours();
			clockMinute = GetClockMinutes();
			if(clockMinute < 10) then
				clockMinute = '0'..clockMinute
			end
			clockDisplay = clockHour..":"..clockMinute;
		end

		
		
		--Récuperation de la quantité d'argent présente sur les 3 comptes du joueur (bank, wallet, black_money)
		for k,v in ipairs(playerData.accounts) do
			if(v.name == "money") then
				moneyWallet = ESX.Math.GroupDigits(v.money)
			end
				
			if(v.name == "bank") then
				moneyBank = ESX.Math.GroupDigits(v.money)
			end
				
			if(v.name == "black_money") then
				moneyDirty = ESX.Math.GroupDigits(v.money)
			end	
		end

		
		--Envoi une structure composée de toutes les données récoltées vers le script.js pour affichage
        SendNUIMessage({
            hud = Config['Hud'];
			clockOn = Config['clock'];
            pauseMenu = IsPauseMenuActive();
            armour = GetPedArmour(PlayerPedId());
            health = GetEntityHealth(PlayerPedId())-100;
            food = food;
            thirst = thirst;
            playerid = playeridInput;
            fuel = fuelEvent;
            hudPosition = hudPosition;
            fuelPosition = fuelPosition;
			wallet = moneyWallet;
			bank = moneyBank;
			dirty = moneyDirty;
			company = moneyCompany;
			clockDisplay = clockDisplay;
        })
		
		
    end
end)
-- Fin THREAD[2] --------------------------------------------------------------------------------------------




--TODO: *1* : comparer la ligne [localPlayerID = playerid] avec une version du code antérieure et voir si elle est utile. (pareil pour les autre références de la variable playerid dans la suite du code)
--		*2* : Comparer en affichant les valeurs de [PlayerPed] et [PlayerPedId], puis utiliser la boucle [for v,k in pairs(X)] pour fouiller dans chacun des deux objets [Ped] que l'on récupére grace à ces fonctions