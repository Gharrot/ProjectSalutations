package;

import locations.*;
import sound.SoundManager;
import flixel.util.FlxArrayUtil;
import flixel.util.FlxSave;
import haxe.Serializer;
import haxe.Unserializer;
import flixel.FlxG;

class GameVariables {
	//Option Vars
	public var infiniteFood:Bool;
	
	//General Vars
    public var controlledDeer:Array<Deer>;
	public var maxPackSize:Int;
	
    public var undergroundCityDeer:Array<Deer>;
	
    public var babyDeer:Array<Deer>;
	public var maxBabyPackSize:Int;
	
    public var currentLocation:Location;
    public var currentLocationName:String;

	public var currentDay:Int;
	
    public var currentFood:Int;
    public var maxFood:Int;
	
	public var inventory:Inventory;
	
	public var rabbitFur:Int;
	public var rabbitFurBeddingMade:Bool;
	
	//Unfamiliar Woods
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
	public var unfamiliarWoodsPathToDarkWoodsFound:Bool;
	
	//Abandoned Fields
	public var abandonedFieldsMaxFood:Int;
	
	//Dark Forest
	public var darkForestMaxFood:Int;
	public var darkForestTimeRemaining:Int;
	public var darkForestWolves:Array<EnemyWolf>;
	public var darkForestHealingSpringFound:Bool;
	public var darkForestHealingBerriesFound:Bool;
	public var darkForestSpeedHerbsFound:Bool;
    public var darkForestPedestalRaised:Bool;
    public var darkForestMedallionTaken:Bool;
	
	//Ghost Town
	public var ghostTownMaxFood:Int;
	
	//The Trail
	public var theTrailMaxFood:Int;
	public var theTrailDayNumber:Int;
	public var theTrailDayPlanksFound:Bool;
	public var theTrailDayStonesFound:Bool;
	public var theTrailDayRopesFound:Bool;
	public var theTrailDayStreamFound:Bool;
	public var theTrailDayBridgeFound:Bool;
	public var theTrailDayMedallionTaken:Bool;
	public var theTrailCompleted:Bool;
	
	//Underground City
	public var undergroundCityReached:Bool;
	public var undergroundCityOpened:Bool;
	public var undergroundCityChurchViewed:Bool;
	public var undergroundCityLabsViewed:Bool;
	public var undergroundCityObservatoryViewed:Bool;
	
	//Squirrel Village
	public var squirrelVillageBeddingChoice:String;
	public var leaderShipSkillsEarned:Bool;
	public var squirrelVillageMountaineeringChallegeDay:Bool;
	
	//Mount Vire
	public var mountVireAcorns:Int;
	public var mountVireFoodPacks:Int;
	public var mountVireExplosives:Int;
	public var mountVirePineLogs:Int;
	public var mountVireMapleLogs:Int;
	public var mountVireLocation:String;
	public var mountVireMountainPathBlockage:Int;
	public var mountVireSilverCaveBlockage:Int;
	public var mountVireStoneAcorns:Int;
	public var mountVireKeyTaken:Bool;
	
	//Onsen Peak
	public var onsenPeakStatChoice:String;
	
	//Dark City
	public var darkCityReached:Bool;
	public var darkCitySticks:Int;
	public var darkCityBarricades:Int;
	public var darkCityScurriers:Int;
	public var darkCityWidgetsObtained:Int;
	public var darkCityWidgetsInstalled:Int;
	
	public var saveNum:Int;

    public static var instance(default, null):GameVariables = new GameVariables();

    private function new() {
		initialize();
    }
	
	public function initialize()
	{
		initializeVariables();
        controlledDeer = new Array();
		maxPackSize = 4;
        babyDeer = new Array();
		maxBabyPackSize = 2;
		
        currentLocation = new ForgottenWoods();
		currentLocationName = "Unfamiliar Woods";
        currentFood = 4;
        maxFood = 12;
		
		unfamiliarWoodsMaxFood = 12;
		rabbitFur = 0;
		rabbitFurBeddingMade = false;
		unfamiliarWoodsLostDeer = new Array<Deer>();
		
		abandonedFieldsMaxFood = 12;
	}
	
	public function changeLocation(targetLocation:String, ?resetLocationVariables:Bool = true){
		if (targetLocation == "Unfamiliar Woods")
		{
			currentLocation = new ForgottenWoods();
			maxFood = unfamiliarWoodsMaxFood;
		}
		else if (targetLocation == "Abandoned Fields")
		{
			currentLocation = new AbandonedFields();
			maxFood = abandonedFieldsMaxFood;
		}
		else if (targetLocation == "Dark Forest")
		{
			currentLocation = new DarkForest();
			maxFood = darkForestMaxFood;
			
			if(resetLocationVariables){
				darkForestWolves = new Array<EnemyWolf>();
				darkForestWolves.push(new EnemyWolf());
				darkForestWolves.push(new EnemyWolf());
				
				if(!darkForestPedestalRaised){
					darkForestTimeRemaining = 5;
				}
				else
				{
					darkForestTimeRemaining = 0;
				}
			}
		}
		else if (targetLocation == "Ghost Town")
		{
			currentLocation = new GhostTown();
			maxFood = ghostTownMaxFood;
		}
		else if (targetLocation == "The Trail")
		{
			currentLocation = new TheTrail();
			maxFood = theTrailMaxFood;
			
			if (resetLocationVariables){
				theTrailDayNumber = 1;
			}
			
			cast(currentLocation, TheTrail).updateBackgroundImages();
		}
		else if (targetLocation == "Stone Stronghold Entrance")
		{
			currentLocation = new StoneStrongholdEntrance();
			maxFood = 12;
		}
		else if (targetLocation == "Underground City")
		{
			currentLocation = new UndergroundCity();
			maxFood = 20;
		}
		else if (targetLocation == "Squirrel Village")
		{
			currentLocation = new SquirrelVillage();
			maxFood = 15;
			
			if (resetLocationVariables)
			{
				cast(currentLocation, SquirrelVillage).mountaineeringChallengeStartingTomorrow = false;
				cast(currentLocation, SquirrelVillage).mountaineeringChallengeActive = false;
				cast(currentLocation, SquirrelVillage).buyingPhase = false;
				
				squirrelVillageMountaineeringChallegeDay = false;
			}
			else
			{
				if (squirrelVillageMountaineeringChallegeDay)
				{
					cast(currentLocation, SquirrelVillage).mountaineeringChallengeActive = true;
				}
			}
			
			mountVireFoodPacks = 0;
			mountVireExplosives = 0;
			mountVirePineLogs = 0;
			mountVireMapleLogs = 0;
		}
		else if (targetLocation == "Mount Vire")
		{
			currentLocation = new MountVire();
			maxFood = 12;
			
			if (resetLocationVariables)
			{
				mountVireLocation = "Base camp";
				mountVireMountainPathBlockage = 5;
				mountVireSilverCaveBlockage = 7;
				cast(currentLocation, MountVire).updateBackgroundImages();
			}
		}
		else if (targetLocation == "Onsen Peak")
		{
			currentLocation = new OnsenPeak();
			maxFood = 12;
		}
		else if (targetLocation == "Dark City")
		{
			currentLocation = new DarkCity();
			maxFood = 20;
			
			if (resetLocationVariables)
			{
				darkCitySticks = 0;
				darkCityBarricades = 0;
				darkCityScurriers = 0;
				darkCityWidgetsObtained = 0;
				darkCityWidgetsInstalled = 0;
			}
		}
		
		currentLocationName = targetLocation;
		setBG();
		currentLocation.playMusic();
		
		if (resetLocationVariables)
		{
			removeLocationLockedStatuses();
		}
		checkVariables();
	}
	
	public static function getLocationByName(targetLocation:String):Location
	{
		if (targetLocation == "Unfamiliar Woods")
		{
			return new ForgottenWoods();
		}
		else if (targetLocation == "Abandoned Fields")
		{
			return new AbandonedFields();
		}
		else if (targetLocation == "Dark Forest")
		{
			return new DarkForest();
		}
		else if (targetLocation == "Ghost Town")
		{
			return new GhostTown();
		}
		else if (targetLocation == "The Trail")
		{
			return new TheTrail();
		}
		else if (targetLocation == "Stone Stronghold Entrance")
		{
			return new StoneStrongholdEntrance();
		}
		else if (targetLocation == "Underground City")
		{
			return new UndergroundCity();
		}
		else if (targetLocation == "Squirrel Village")
		{
			return new SquirrelVillage();
		}
		else if (targetLocation == "Mount Vire")
		{
			return new MountVire();
		}
		else if (targetLocation == "Onsen Peak")
		{
			return new OnsenPeak();
		}
		else if (targetLocation == "Dark City")
		{
			return new DarkCity();
		}
		else
		{
			return new ForgottenWoods();
		}
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
		
		currentDay++;
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
	
	public function getControlledDeer(?includePlayer:Bool = true):Array<Deer>{
		var deer:Array<Deer> = new Array<Deer>();
		
		for (i in 0...controlledDeer.length){
			if (includePlayer || !controlledDeer[i].player)
			{
				deer.push(controlledDeer[i]);
			}
		}
		
		return deer;
	}
	
	public function getUndergroundCityDeer():Array<Deer>{
		var deer:Array<Deer> = new Array<Deer>();
		
		for (i in 0...undergroundCityDeer.length){
			deer.push(undergroundCityDeer[i]);
		}
		
		return deer;
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
	
	public function getMedallionCount():Int
	{
		var medallionCount:Int = 0;
		
		if (unfamiliarWoodsMedallionTaken)
		{
			medallionCount++;
		}
		
		if (darkForestMedallionTaken)
		{
			medallionCount++;
		}
		
		if (theTrailDayMedallionTaken)
		{
			medallionCount++;
		}
		
		return medallionCount;
	}
	
	public function removeLocationLockedStatuses()
	{
		for (i in 0...controlledDeer.length)
		{
			var currentDeer:Deer = controlledDeer[i];
			
			if (currentDeer.checkForStatusByName("Carrying Planks"))
			{
				currentDeer.removeStatusByName("Carrying Planks");
			}
			
			if (currentDeer.checkForStatusByName("Carrying Ropes"))
			{
				currentDeer.removeStatusByName("Carrying Ropes");
			}
		}
	}
	
	public function initializeVariables(){
		//Option Vars
		infiniteFood = false;
		
		//General Vars
        controlledDeer = new Array();
		maxPackSize = 4;
        babyDeer = new Array();
		maxBabyPackSize = 2;
		
        undergroundCityDeer = new Array();
		
		inventory = new Inventory();
		
        currentLocation = new ForgottenWoods();
		currentLocationName = "Unfamiliar Woods";
        currentFood = 4;
        maxFood = 12;
		
		currentDay = 1;
		
		//Unfamiliar Woods
		unfamiliarWoodsMaxFood = 12;
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
		unfamiliarWoodsPathToDarkWoodsFound = false;
		
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
		
		//Ghost Town
		ghostTownMaxFood = 12;
		
		//The Trail
		theTrailMaxFood = 12;
		theTrailDayNumber = 1;
		theTrailDayPlanksFound = false;
		theTrailDayStonesFound = false;
		theTrailDayRopesFound = false;
		theTrailDayStreamFound = false;
		theTrailDayBridgeFound = false;
		theTrailDayMedallionTaken = false;
		theTrailCompleted = false;
		
		//Underground City
		undergroundCityReached = false;
		undergroundCityOpened = false;
		undergroundCityChurchViewed = false;
		undergroundCityLabsViewed = false;
		undergroundCityObservatoryViewed = false;
	
		//Squirrel Village
		squirrelVillageBeddingChoice = "None";
		leaderShipSkillsEarned = false;
		squirrelVillageMountaineeringChallegeDay = false;
		
		//Mount Vire
		mountVireAcorns = 0;
		mountVireFoodPacks = 0;
		mountVireExplosives = 0;
		mountVirePineLogs = 0;
		mountVireMapleLogs = 0;
		mountVireLocation = "Base camp";
		mountVireMountainPathBlockage = 5;
		mountVireSilverCaveBlockage = 8;
		mountVireStoneAcorns = 0;
		mountVireKeyTaken = false;
		
		//Onsen Peak
		onsenPeakStatChoice = "None";
		
		//Dark City
		darkCityReached = false;
		darkCitySticks = 0;
		darkCityBarricades = 0;
		darkCityScurriers = 0;
		darkCityWidgetsObtained = 0;
		darkCityWidgetsInstalled = 0;
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
		else if (locationName == "Ghost Town")
		{
			return "assets/images/LocationImages/GhostTown.png";
		}
		else if (locationName == "The Trail")
		{
			return "assets/images/LocationImages/AbandonedFields.png";
		}
		else if (locationName == "Stone Stronghold Entrance")
		{
			return "assets/images/LocationImages/StoneOverlook.png";
		}
		else if (locationName == "Underground City")
		{
			return "assets/images/LocationImages/UndergroundCity.png";
		}
		else if (locationName == "Squirrel Village")
		{
			return "assets/images/LocationImages/SquirrelVillage.png";
		}
		
		return "assets/images/LocationImages/ForgottenWoods.png";
	}
	
	public function setBG()
	{
		if (currentLocationName == "Unfamiliar Woods")
		{
			FlxG.state.bgColor = 0xFFD8F6F3;
		}
		else if (currentLocationName == "Abandoned Fields")
		{
			FlxG.state.bgColor = 0xFFD8F6F3;
		}
		else if (currentLocationName == "Dark Forest")
		{
			FlxG.state.bgColor = 0xFF363641;
		}
		else if (currentLocationName == "Underground City")
		{
			FlxG.state.bgColor = 0xFFA6A6A6;
		}
		else
		{
			FlxG.state.bgColor = 0xFFD8F6F3;
		}
	}
}