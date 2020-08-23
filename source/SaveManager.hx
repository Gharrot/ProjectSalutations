package;

import flixel.util.FlxSave;

class SaveManager 
{
	
	static public function loadSave(saveName:String){
		var save:FlxSave = new FlxSave();
		save.bind(saveName);
		
		var gameVariables:GameVariables = GameVariables.instance;
		
        gameVariables.controlledDeer = save.data.controlledDeer;
		gameVariables.maxPackSize = save.data.maxPackSize;
        gameVariables.babyDeer = save.data.babyDeer;
		gameVariables.maxBabyPackSize = save.data.maxBabyPackSize;
		
        gameVariables.undergroundCityDeer = save.data.undergroundCityDeer;

        gameVariables.currentFood = save.data.currentFood;
		gameVariables.maxFood = save.data.maxFood;
		
		//Unfamiliar Woods
		gameVariables.unfamiliarWoodsMaxFood = save.data.unfamiliarWoodsMaxFood;
		gameVariables.rabbitFur = save.data.rabbitFur;
		gameVariables.unfamiliarWoodsLostDeer = save.data.unfamiliarWoodsLostDeer;
		gameVariables.unfamiliarWoodsCaveFound = save.data.unfamiliarWoodsCaveFound;
		gameVariables.unfamiliarWoodsMedallionTaken = save.data.unfamiliarWoodsMedallionTaken;
		gameVariables.unfamiliarWoodsDeepWoodsFound = save.data.unfamiliarWoodsDeepWoodsFound;
		gameVariables.unfamiliarWoodsDeepWoodsThicketNavigated = save.data.unfamiliarWoodsDeepWoodsThicketNavigated;
		gameVariables.unfamiliarWoodsDeepWoodsThicketCleared = save.data.unfamiliarWoodsDeepWoodsThicketCleared;
		gameVariables.unfamiliarWoodsIntellectSpringFound = save.data.unfamiliarWoodsIntellectSpringFound;
		gameVariables.unfamiliarWoodsInspiringViewFound = save.data.unfamiliarWoodsInspiringViewFound;
		gameVariables.unfamiliarWoodsSquirrelsOfGoodFortuneFound = save.data.unfamiliarWoodsSquirrelsOfGoodFortuneFound;
		gameVariables.unfamiliarWoodsPathToDarkWoodsFound = save.data.unfamiliarWoodsPathToDarkWoodsFound;
		
		//Abandoned Fields
		gameVariables.abandonedFieldsMaxFood = save.data.abandonedFieldsMaxFood;
		
		//Dark Forest
		gameVariables.darkForestMaxFood = save.data.darkForestMaxFood;
		gameVariables.darkForestTimeRemaining = save.data.darkForestTimeRemaining;
		gameVariables.darkForestWolves = save.data.darkForestWolves;
		gameVariables.darkForestPedestalRaised = save.data.darkForestPedestalRaised;
		gameVariables.darkForestMedallionTaken = save.data.darkForestMedallionTaken;
		
		//Ghost Town
		gameVariables.ghostTownMaxFood = save.data.ghostTownMaxFood;
		
		//The Trail
		gameVariables.theTrailMaxFood = save.data.theTrailMaxFood;
		gameVariables.theTrailDayNumber = save.data.theTrailDayNumber;
		gameVariables.theTrailDayPlanksFound = save.data.theTrailDayPlanksFound;
		gameVariables.theTrailDayStonesFound = save.data.theTrailDayStonesFound;
		gameVariables.theTrailDayRopesFound = save.data.theTrailDayRopesFound;
		gameVariables.theTrailDayStreamFound = save.data.theTrailDayStreamFound;
		gameVariables.theTrailDayBridgeFound = save.data.theTrailDayBridgeFound;
		gameVariables.theTrailDayMedallionTaken = save.data.theTrailDayMedallionTaken;
		
		//Underground City
		gameVariables.undergroundCityReached = save.data.undergroundCityReached;
		gameVariables.undergroundCityOpened = save.data.undergroundCityOpened;
		
		//Squirrel Village
		gameVariables.beddingChoice = save.data.beddingChoice;
		gameVariables.leaderShipSkillsEarned = save.data.leaderShipSkillsEarned;
		gameVariables.mountaineeringChallegeDay = save.data.mountaineeringChallegeDay;
		
		//Mount Vire
		gameVariables.mountVireAcorns = save.data.mountVireAcorns;
		gameVariables.mountVireFoodPacks = save.data.mountVireFoodPacks;
		gameVariables.mountVireExplosives = save.data.mountVireExplosives;
		gameVariables.mountVirePineLogs = save.data.mountVirePineLogs;
		gameVariables.mountVireMapleLogs = save.data.mountVireMapleLogs;
		gameVariables.mountVireLocation = save.data.mountVireLocation;
		gameVariables.mountVireMountainPathBlockage = save.data.mountVireMountainPathBlockage;
		
		//move to the correct location
		gameVariables.currentLocationName = save.data.currentLocationName;
		gameVariables.changeLocation(gameVariables.currentLocationName, false);
	}
	
	static public function saveGame(saveName:String){
		var save:FlxSave = new FlxSave();
		save.bind(saveName);
		
		var gameVariables:GameVariables = GameVariables.instance;
		
        save.data.controlledDeer = gameVariables.controlledDeer;
		save.data.maxPackSize = gameVariables.maxPackSize;
        save.data.babyDeer = gameVariables.babyDeer;
		save.data.maxBabyPackSize = gameVariables.maxBabyPackSize;
		
        save.data.undergroundCityDeer = gameVariables.undergroundCityDeer;

		save.data.currentLocationName = gameVariables.currentLocationName;
        save.data.currentFood = gameVariables.currentFood;
		
		//Unfamiliar Woods
		save.data.unfamiliarWoodsMaxFood = gameVariables.unfamiliarWoodsMaxFood;
		save.data.rabbitFur = gameVariables.rabbitFur;
		save.data.unfamiliarWoodsLostDeer = gameVariables.unfamiliarWoodsLostDeer;
		save.data.unfamiliarWoodsCaveFound = gameVariables.unfamiliarWoodsCaveFound;
		save.data.unfamiliarWoodsMedallionTaken = gameVariables.unfamiliarWoodsMedallionTaken;
		save.data.unfamiliarWoodsDeepWoodsFound = gameVariables.unfamiliarWoodsDeepWoodsFound;
		save.data.unfamiliarWoodsDeepWoodsThicketNavigated = gameVariables.unfamiliarWoodsDeepWoodsThicketNavigated;
		save.data.unfamiliarWoodsDeepWoodsThicketCleared = gameVariables.unfamiliarWoodsDeepWoodsThicketCleared;
		save.data.unfamiliarWoodsIntellectSpringFound = gameVariables.unfamiliarWoodsIntellectSpringFound;
		save.data.unfamiliarWoodsInspiringViewFound = gameVariables.unfamiliarWoodsInspiringViewFound;
		save.data.unfamiliarWoodsSquirrelsOfGoodFortuneFound = gameVariables.unfamiliarWoodsSquirrelsOfGoodFortuneFound;
		save.data.unfamiliarWoodsPathToDarkWoodsFound = gameVariables.unfamiliarWoodsPathToDarkWoodsFound;
		
		//Abandoned Fields
		save.data.abandonedFieldsMaxFood = gameVariables.abandonedFieldsMaxFood;
		
		//Dark Forest
		save.data.darkForestMaxFood = gameVariables.darkForestMaxFood;
		save.data.darkForestTimeRemaining = gameVariables.darkForestTimeRemaining;
		save.data.darkForestWolves = gameVariables.darkForestWolves;
		save.data.darkForestPedestalRaised = gameVariables.darkForestPedestalRaised;
		save.data.darkForestMedallionTaken = gameVariables.darkForestMedallionTaken;
		
		//Ghost Town
		save.data.ghostTownMaxFood = gameVariables.ghostTownMaxFood;
		
		//The Trail
		save.data.theTrailMaxFood = gameVariables.theTrailMaxFood;
		save.data.theTrailDayNumber = gameVariables.theTrailDayNumber;
		save.data.theTrailDayPlanksFound = gameVariables.theTrailDayPlanksFound;
		save.data.theTrailDayStonesFound = gameVariables.theTrailDayStonesFound;
		save.data.theTrailDayRopesFound = gameVariables.theTrailDayRopesFound;
		save.data.theTrailDayStreamFound = gameVariables.theTrailDayStreamFound;
		save.data.theTrailDayBridgeFound = gameVariables.theTrailDayBridgeFound;
		save.data.theTrailDayMedallionTaken = gameVariables.theTrailDayMedallionTaken;
		
		//Underground City
		save.data.undergroundCityReached = gameVariables.undergroundCityReached;
		save.data.undergroundCityOpened = gameVariables.undergroundCityOpened;
		
		//Squirrel Village
		save.data.beddingChoice = gameVariables.beddingChoice;
		save.data.leaderShipSkillsEarned = gameVariables.leaderShipSkillsEarned;
		save.data.mountaineeringChallegeDay = gameVariables.mountaineeringChallegeDay;
		
		//Mount Vire
		save.data.mountVireAcorns = gameVariables.mountVireAcorns;
		save.data.mountVireFoodPacks = gameVariables.mountVireFoodPacks;
		save.data.mountVireExplosives = gameVariables.mountVireExplosives;
		save.data.mountVirePineLogs = gameVariables.mountVirePineLogs;
		save.data.mountVireMapleLogs = gameVariables.mountVireMapleLogs;
		save.data.mountVireLocation = gameVariables.mountVireLocation;
		save.data.mountVireMountainPathBlockage = gameVariables.mountVireMountainPathBlockage;
		
		save.flush();
	}
	
}