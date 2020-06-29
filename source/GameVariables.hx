package;

import locations.*;
import flixel.util.FlxArrayUtil;
import flixel.util.FlxSave;
import haxe.Serializer;
import haxe.Unserializer;

class GameVariables {
    public var controlledDeer:Array<Deer>;
	public var maxPackSize:Int;
	
    public var babyDeer:Array<Deer>;
	public var maxBabyPackSize:Int;
	
    public var currentLocation:Location;
    public var currentLocationName:String;

    public var currentFood:Int;
    public var maxFood:Int;
	
	public var rabbitFur:Int;
	public var rabbitFurBeddingMade:Bool;
	
	public var unfamiliarWoodsMaxFood:Int;
    public var unfamiliarWoodsLostDeer:Array<Deer>;
    public var unfamiliarWoodsCaveFound:Bool;
    public var unfamiliarWoodsDeepWoodsFound:Bool;
    public var unfamiliarWoodsDeepWoodsThicketNavigated:Bool;
    public var unfamiliarWoodsDeepWoodsThicketCleared:Bool;
    public var unfamiliarWoodsIntellectSpringFound:Bool;
    public var unfamiliarWoodsInspiringViewFound:Bool;
    public var unfamiliarWoodsSquirrelsOfGoodFortuneFound:Bool;
    public var unfamiliarWoodsMedallionTaken:Bool;
	
	public var abandonedFieldsMaxFood:Int;
	
	public var darkForestMaxFood:Int;
	public var darkForestTimeRemaining:Int;
	public var darkForestWolves:Array<EnemyWolf>;
	public var darkForestHealingSpringFound:Bool;
	public var darkForestHealingBerriesFound:Bool;
	public var darkForestSpeedHerbsFound:Bool;
    public var darkForestPedestalRaised:Bool;
    public var darkForestMedallionTaken:Bool;
	
	public var saveNum:Int;

    public static var instance(default, null):GameVariables = new GameVariables();

    private function new() {
		initializeVariables();
        controlledDeer = new Array();
		maxPackSize = 4;
        babyDeer = new Array();
		maxBabyPackSize = 2;
		
        currentLocation = new ForgottenWoods();
		currentLocationName = "Unfamiliar Woods";
        currentFood = 4;
        maxFood = 10;
		
		unfamiliarWoodsMaxFood = 10;
		rabbitFur = 0;
		rabbitFurBeddingMade = false;
		unfamiliarWoodsLostDeer = new Array<Deer>();
		
		abandonedFieldsMaxFood = 12;
    }
	
	public function changeLocation(targetLocation:String, ?resetLocationVariables:Bool = true){		
		if(targetLocation == "Unfamiliar Woods"){
			currentLocation = new ForgottenWoods();
			maxFood = unfamiliarWoodsMaxFood;
		}
		else if(targetLocation == "Abandoned Fields"){
			currentLocation = new AbandonedFields();
			maxFood = abandonedFieldsMaxFood;
		}
		else if(targetLocation == "Dark Forest"){
			currentLocation = new DarkForest();
			maxFood = darkForestMaxFood;
			
			if(resetLocationVariables){
				darkForestWolves = new Array<EnemyWolf>();
				darkForestWolves.push(new EnemyWolf());
				darkForestWolves.push(new EnemyWolf());
				
				if(!darkForestPedestalRaised){
					darkForestTimeRemaining = 6;
				}
			}
		}
		
		currentLocationName = targetLocation;
		checkVariables();
	}
	
	public function checkVariables(){
		if(currentFood > maxFood){
			currentFood = maxFood;
		}
	}
	
	public function advanceDay(){
		//loop backwards through controlled deer
		var originalLength:Int = controlledDeer.length;
		for (i in 1...(originalLength+1)) {
			var currentDeer:Deer = controlledDeer[originalLength - i];
			currentDeer.updateStatuses();
		}
		
		//loop backwards through baby deer
		originalLength = babyDeer.length;
		for (i in 1...(originalLength+1)) {
			var currentDeer:Deer = babyDeer[originalLength - i];
			currentDeer.updateStatuses();
		}
	}
	
	public function modifyFood(amount:Int){
		currentFood += amount;
		if(currentFood < 0){
			currentFood = 0;
		}
		
		var realMaxFood:Int = cast(Math.ceil(maxFood * 1.5), Int);
		
		if(currentFood > realMaxFood){
			currentFood = realMaxFood;
		}
	}
	
	public function addDeer(deer:Deer){
		controlledDeer[controlledDeer.length] = deer;
	}
	
	public function addFoundDeer(deer:Deer){
		deer.currentAction = "Waiting";
		addDeer(deer);
	}
	
	public function addBabyDeer(deer:Deer){
		babyDeer.push(deer);
		deer.currentAction = "Baby";
	}
	
	public function prepareDeer(){
		for(i in 0...controlledDeer.length){
			if(controlledDeer[i].currentAction == "Waiting"){
				controlledDeer[i].currentAction = "Foraging";
			}
		}
	}
	
	public function healAllDeer()
	{
		for(i in 0...controlledDeer.length){
			if(controlledDeer[i].health < controlledDeer[i].maxHealth){
				controlledDeer[i].health = controlledDeer[i].maxHealth;
			}
		}
	}
	
	public function loseAllDeer(){
		//loop backwards through controlled deer
		var originalLength:Int = controlledDeer.length;
		for (i in 1...originalLength) {
			var currentDeer:Deer = controlledDeer[originalLength - i];
			loseControlledDeer(currentDeer);
		}
	}
	
	public function loseControlledDeer(deer:Deer){
		unfamiliarWoodsLostDeer[unfamiliarWoodsLostDeer.length] = deer;
		deer.removeAllStatusEffects();
		controlledDeer.remove(deer);
	}
	
	public function banishControlledDeer(deer:Deer){
		controlledDeer.remove(deer);
	}
	
	public function getPlayerDeer():Deer{
		for(i in 0...controlledDeer.length){
			if(controlledDeer[i].player){
				return controlledDeer[i];
			}
		}
		
		return Deer.getNewBlankDeer();
	}
	
	public function getMaleDeer(?available:Bool = true):Array<Deer>{
		var maleDeer:Array<Deer> = new Array<Deer>();
		
		for(i in 0...controlledDeer.length){
			if(controlledDeer[i].gender == "Male"){
				if(!available || controlledDeer[i].isAvailable()){
					maleDeer[maleDeer.length] = controlledDeer[i];
				}
			}
		}
		
		return maleDeer;
	}
	
	public function getFemaleDeer(?available:Bool = true):Array<Deer>{
		var femaleDeer:Array<Deer> = new Array<Deer>();
		
		for(i in 0...controlledDeer.length){
			if (controlledDeer[i].gender == "Female") {
				if(!available || controlledDeer[i].isAvailable()){
					femaleDeer[femaleDeer.length] = controlledDeer[i];
				}
			}
		}
		
		return femaleDeer;
	}
	
	public function getRestingDeer():Array<Deer>{
		var restingDeer:Array<Deer> = new Array<Deer>();
		
		for (i in 0...controlledDeer.length) {
			if (!controlledDeer[i].actedThisRound && controlledDeer[i].currentAction == "Resting") {
				controlledDeer[i].actedThisRound = true;
				restingDeer.push(controlledDeer[i]);
			}
        }
		
		return restingDeer;
	}
	
	public function loadFromSave(){
		SaveManager.loadSave("Save" + saveNum);
	}
	
	public function saveGameData(){
		//var serializer = new Serializer();
		//serializer.useCache = true;
		//serializer.serialize(this);
		
		//var save:FlxSave = new FlxSave();
		//save.bind();
		//save.data.gameVariables = this;
		//save.flush();
		
		SaveManager.saveGame("Save" + saveNum);
	}
	
	public function addUnfamiliarWoodsRabbitFur(){
		rabbitFur++;
		if(rabbitFur > 5){
			rabbitFur = 5;
		}
	}
	
	public function initializeVariables(){
        controlledDeer = new Array();
		maxPackSize = 4;
        babyDeer = new Array();
		maxBabyPackSize = 2;
		
        currentLocation = new ForgottenWoods();
		currentLocationName = "Unfamiliar Woods";
        currentFood = 4;
        maxFood = 10;
		
		//Unfamiliar Woods
		unfamiliarWoodsMaxFood = 10;
		rabbitFur = 0;
		unfamiliarWoodsLostDeer = new Array<Deer>();
		unfamiliarWoodsCaveFound = false;
		unfamiliarWoodsMedallionTaken = false;
		unfamiliarWoodsDeepWoodsFound = false;
		unfamiliarWoodsDeepWoodsThicketNavigated = false;
		unfamiliarWoodsDeepWoodsThicketCleared = false;
		unfamiliarWoodsIntellectSpringFound = false;
		unfamiliarWoodsInspiringViewFound = false;
		unfamiliarWoodsSquirrelsOfGoodFortuneFound = false;
		
		//Abandoned Fields
		abandonedFieldsMaxFood = 12;
		
		//Dark Forest
		darkForestMaxFood = 8;
		darkForestTimeRemaining = 10;
		darkForestWolves = new Array<EnemyWolf>();
		darkForestHealingSpringFound = false;
		darkForestHealingBerriesFound = false;
		darkForestSpeedHerbsFound = false;
		darkForestPedestalRaised = false;
		darkForestMedallionTaken = false;
	}
	
	public static function getLocationSpriteByName(locationName:String):String
	{	
		if (locationName == "Unfamiliar Woods")
		{
			return "assets/images/LocationImages/ForgottenWoods.png";
		}
		else if (locationName == "Abandoned Fields")
		{
			return "assets/images/LocationImages/AbandonedFields.png";
		}
		else if (locationName == "Dark Forest")
		{
			return "assets/images/LocationImages/DarkForest.png";
		}
		
		return "dang";
	}
}