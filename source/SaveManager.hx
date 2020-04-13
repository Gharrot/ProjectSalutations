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

        //gameVariables.currentLocation = new ForgottenWoods();
		//gameVariables.currentLocationName = "Unfamiliar Woods";
        gameVariables.currentFood = save.data.currentFood;
		//gameVariables.maxFood = 10;
		
		//UnfamiliarWoods
		//gameVariables.unfamiliarWoodsMaxFood = save.data.unfamiliarWoodsMaxFood;
		//gameVariables.rabbitFur = save.data.rabbitFur;
		//gameVariables.unfamiliarWoodsLostDeer = save.data.unfamiliarWoodsLostDeer;
		//gameVariables.unfamiliarWoodsCaveFound = save.data.unfamiliarWoodsCaveFound;
		//gameVariables.unfamiliarWoodsMedallionTaken = save.data.unfamiliarWoodsMedallionTaken;
		//gameVariables.unfamiliarWoodsDeepWoodsFound = save.data.unfamiliarWoodsDeepWoodsFound;
		//gameVariables.unfamiliarWoodsDeepWoodsThicketNavigated = save.data.unfamiliarWoodsDeepWoodsThicketNavigated;
		//gameVariables.unfamiliarWoodsDeepWoodsThicketCleared = save.data.unfamiliarWoodsDeepWoodsThicketCleared;
		//gameVariables.unfamiliarWoodsIntellectSpringFound = save.data.unfamiliarWoodsIntellectSpringFound;
		//gameVariables.unfamiliarWoodsInspiringViewFound = save.data.unfamiliarWoodsInspiringViewFound;
		//gameVariables.unfamiliarWoodsSquirrelsOfGoodFortuneFound = save.data.unfamiliarWoodsSquirrelsOfGoodFortuneFound;
		//
		//gameVariables.abandonedFieldsMaxFood = save.data.abandonedFieldsMaxFood;
	}
	
	static public function saveGame(saveName:String){
		var save:FlxSave = new FlxSave();
		save.bind(saveName);
		
		var gameVariables:GameVariables = GameVariables.instance;
		
        save.data.controlledDeer = gameVariables.controlledDeer;
		save.data.maxPackSize = gameVariables.maxPackSize;
        save.data.babyDeer = gameVariables.babyDeer;
		save.data.maxBabyPackSize = gameVariables.maxBabyPackSize;

        //gameVariables.currentLocation = new ForgottenWoods();
		//gameVariables.currentLocationName = "Unfamiliar Woods";
        save.data.currentFood = gameVariables.currentFood;
		
		save.flush();
	}
	
}