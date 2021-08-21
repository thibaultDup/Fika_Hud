--Initialisation de la variable ESX à nil
ESX = nil


--Récupération de l'object ESX et affectation à la variable ESX
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


--EVENTS --------------------------------------------------------------------------------------------

--Event permetant de récupérer le montant sur le compte d'une entreprise en fonction du métier du joueur
RegisterNetEvent('Fika_Hud:GetSocietyAccount')
AddEventHandler("Fika_Hud:GetSocietyAccount", function()

		--getJob().name = le nom général du job  /  getJob().grade = valeur numérique du grade (val max diffère en fonction du job)  /  getJob().grade_name = nom du grade (boss, assistant etc..) 
		xPlayer = ESX.GetPlayerFromId(source)
		jobGradeName = xPlayer.getJob().grade_name
		jobName = xPlayer.getJob().name
		
		moneySociety = -100
		nameSociety = "society_"..jobName
		
		--Si le joueur est PDG(boss) de l'entreprise on récupére le montant du compte societé (car l'on affichera le montant sur le Hud que pour les gestionnaires de l'entreprise)
		if(jobGradeName == 'boss') then
			TriggerEvent('esx_addonaccount:getSharedAccount', nameSociety , function(account)
				moneySociety = account.money
			end)
		end
		
		
		--Trigger l'event client pour pouvoir retourner la valeur que l'on a récuperer à notre client
		TriggerClientEvent('Fika_Hud:GetSocietyAccount:Return', source, moneySociety)
end)

--Fin EVENTS --------------------------------------------------------------------------------------------