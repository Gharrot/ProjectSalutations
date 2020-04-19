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

        gameVariables.currentFood = save.data.currentFood;
		gameVariables.maxFood = save.data.maxFood;
		
		//UnfamiliarWoods
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
		
		gameVariables.abandonedFieldsMaxFood = save.data.abandonedFieldsMaxFood;
		
		//move to the correct location
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

		save.data.currentLocationName = gameVariables.currentLocationName;
        save.data.currentFood = gameVariables.currentFood;
		
		//UnfamiliarWoods
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
		
		//AbandonedFields
		save.data.abandonedFieldsMaxFood = gameVariables.abandonedFieldsMaxFood;
		
		save.flush();
	}
	
}