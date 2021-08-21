window.addEventListener('message', function (event) {
	
	//Cache : l'id du joueur, le niveau de fuel et l'affichage du compte en banque de l'entreprise -
	//- pour ensuite l'afficher ou non en fonction de divers conditions
    $("#StatusHud #playerid").hide()
    $("#StatusHud #fuel").hide()
	$('.textMoneyCompany').hide()
	
	//Charge les données reçu depuis le script [client.lua] dans des variables
	//Inscrit les valeurs dans le contenu HTML des différentes div
    let data = event.data
    loadStats = function(){
		
		health =Math.round(data.health)
		armour = Math.round(data.armour)
		food = Math.round(data.food)
		thirst = Math.round(data.thirst)
		playerid = Math.round(data.playerid)
		fuellevel = Math.round(data.fuel)
		moneyWallet = data.wallet
		moneyBank = data.bank
		moneyDirty = data.dirty
		moneyCompany = data.company
		clockDisplay = data.clockDisplay
		
        $('#shieldval').html(armour)
        $('#hungerlevel').html(food)
        $('#waterlevel').html(thirst)
        $('#playeridlevel').html(playerid)
        $('#fuellevel').html(fuellevel)
		$('#valMoneyWallet').html(moneyWallet)
		$('#valMoneyBank').html(moneyBank)
		$('#valMoneyDirty').html(moneyDirty)
		$('#valMoneyCompany').html(moneyCompany)
		$('#valClockDisplay').html(clockDisplay)
		
		
    }
	

	if (data.hud){
        
		
        loadStats();
		
		//Change la couleur de fond de la vie en fonction du seuil : 50 à 25 = rouge clair / 24 à 11 = rouge / 10 et moins : rouge vif
		if (health != -100){
			
            $('#healtlevel').html(health)
            if (health < 50 && data.health > 25){
				window.document.getElementById("healt").className = "redBack1";
            }
			else if (data.health < 25 && data.health >= 11){
				window.document.getElementById("healt").className = "redBack2";
			}
			else if (data.health <= 10){
				 window.document.getElementById("healt").className = "redBack3";
			}else{
                window.document.getElementById("healt").className = "statback";
            }
			
        }else if(data.health == -100){
			
            $('#healtlevel').html("0")
            window.document.getElementById("healt").className = "redBack3";
			
        }
		
		//Change la couleur de fond de l'armure en fonction du seuil : 50 à 25 = rouge clair / 24 à 11 = rouge / 10 et moins : rouge vif
		if (armour != 0){
			
            if (armour < 50 && armour >= 25){
				window.document.getElementById("shield").className = "redBack1";
            }
			else if (armour < 25 && armour >= 11){
				window.document.getElementById("shield").className = "redBack2";
			}
			else if (armour <= 10){
				window.document.getElementById("shield").className = "redBack3";
			}else{
                window.document.getElementById("shield").className = "statback";
            }
			
        }else if(armour == 0){
			
            window.document.getElementById("shield").className = "statback";
			
        }
		
		//Change la couleur de fond de la nourriture en fonction du seuil : 50 à 25 = rouge clair / 24 à 11 = rouge / 10 et moins : rouge vif
		if (food != 0){
			
            if (food < 50 && food >= 25){
				window.document.getElementById("hunger").className = "redBack1";
            }
			else if (food < 25 && food >= 11){
				window.document.getElementById("hunger").className = "redBack2";
			}
			else if (food <= 10){
				window.document.getElementById("hunger").className = "redBack3";
			}else{
                window.document.getElementById("hunger").className = "statback";
            }
			
        }else if(food == 0){
		
            window.document.getElementById("hunger").className = "redBack3";
			
        }
		
		//Change la couleur de fond de la boisson en fonction du seuil : 50 à 25 = rouge clair / 24 à 11 = rouge / 10 et moins : rouge vif
		if (thirst != 0){
			
            if (thirst < 50 && thirst >= 25){
				window.document.getElementById("water").className = "redBack1";
            }
			else if (thirst < 25 && thirst >= 11){
				window.document.getElementById("water").className = "redBack2";
			}
			else if (thirst <= 10){
				 window.document.getElementById("water").className = "redBack3";
			}else{
                window.document.getElementById("water").className = "statback";
            }
			
        }else if(thirst == 0){
			
            window.document.getElementById("water").className = "redBack3";
			
        }
		
		//Change la couleur de fond de l'essence en fonction du seuil : 50 à 25 = rouge clair / 24 à 11 = rouge / 10 et moins : rouge vif
		if (fuellevel != 0){
			
            if (fuellevel < 25 && fuellevel >= 15){
				window.document.getElementById("fuel").className = "redBack1";
            }
			else if (fuellevel < 15 && fuellevel >= 6){
				window.document.getElementById("fuel").className = "redBack2";
			}
			else if (fuellevel <= 5){
				 window.document.getElementById("fuel").className = "redBack3";
			}else{
                window.document.getElementById("fuel").className = "statback";
            }
			
        }else if(fuellevel == 0){
            window.document.getElementById("fuel").className = "redBack3";
        }
		
		
		//Modifie la position du HUD si le joueur se trouve dans un véhicule
        if(data.hudPosition == 'vehiculePos'){
			//Dans un véhicule
			$("#money").animate({"right": '2.0vh', "bottom":'49.0vh'},200 );
        }else{
			//Hors d'un véhicule
			$("#money").animate({"right": '2.0vh', "bottom":'45.0vh'},350 );
        }
		
		//Affiche la stat "Fuel"(Essence) si le joueur se trouve dans un véhicule
        if(data.fuelPosition == 'right'){
            $("#StatusHud #fuel").show() 
        }else{
            $("#StatusHud #fuel").hide()
        }
		
		//Affiche le montant du compte bancaire de l'entreprise si le joueur est PDG (si le joueur n'est qu'employé, la valeur de -100 est attribué à la varible dans le script lua)
		if(data.company != -100)
		{
			$('.textMoneyCompany').show()
		}
		else
		{
			$('.textMoneyCompany').hide()
		}
		
		//Affiche l'horloge si l'affichage de l'horloge à été activé dans le fichier de configuration
		if(data.clockOn)
		{
			$('#clock').show()
		}
		else if(!data.clockOn)
		{
			$('#clock').hide()
		}
		
		
		//Change la couleur de l'icone de l'horloge en fonction nuit/jour
		//De 7h à 19h59 : icone jaune / De 20h à 6h59 : icone blanche 
		clockParts = clockDisplay.split(':')
		if(clockParts[0] >= 20 || clockParts[0] <= 6)
			window.document.getElementById("clockIcon").style = "color:white;";
		else
			window.document.getElementById("clockIcon").style = "color:rgb(255, 241, 138);";
		
		
		//Affiche l'identifiant du joueur si l'affichage ID à été activé dans le fichier de configuration
		if (playerid) {
            $("#StatusHud #playerid").show() 
        }else if(playerid){
            $("#StatusHud #playerid").hide()
        }
		
		
        $("body").show();
    }
});
