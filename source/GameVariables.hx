package;

import locations.*;
import flixel.util.FlxArrayUtil;
import flixel.util.FlxSave;

class GameVariables {
	public var save:FlxSave;
	
    public var controlledDeer:Array<Deer>;
	public var maxPackSize:Int;
	
    public var babyDeer:Array<Deer>;
	public var maxBabyPackSize:Int;

    public var mainGameMenu:MainGame;

    public var currentLocation:Location;
    public var currentLocationName:String;

    public var currentFood:Int;
    public var maxFood:Int;
	
	public var unfamiliarWoodsMaxFood:Int;
	public var unfamiliarWoodsDenRabbitFur:Int;
    public var unfamiliarWoodsLostDeer:Array<Deer>;
    public var unfamiliarWoodsCaveFound:Bool;
    public var unfamiliarWoodsMedallionTaken:Bool;
    public var unfamiliarWoodsDeepWoodsFound:Bool;
    public var unfamiliarWoodsDeepWoodsThicketNavigated:Bool;
    public var unfamiliarWoodsDeepWoodsThicketCleared:Bool;
	
	public var abandonedFieldsMaxFood:Int;
    public var abandonedFieldsLostDeer:Array<Deer>;

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
		unfamiliarWoodsDenRabbitFur = 0;
		unfamiliarWoodsLostDeer = new Array<Deer>();
		
		abandonedFieldsMaxFood = 12;
    }
	
	public function changeLocation(targetLocation:String){
		if(targetLocation == currentLocationName){
			return;
		}
		
		if(targetLocation == "Unfamiliar Woods"){
			currentLocation = new ForgottenWoods();
			maxFood = unfamiliarWoodsMaxFood;
		}
		else if(targetLocation == "Abandoned Fields"){
			currentLocation = new AbandonedFields();
			maxFood = abandonedFieldsMaxFood;
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
		for (i in 1...originalLength) {
			var currentDeer:Deer = controlledDeer[originalLength - i];
			currentDeer.updateStatuses();
		}
		
		//loop backwards through baby deer
		originalLength = babyDeer.length;
		for (i in 1...originalLength) {
			var currentDeer:Deer = babyDeer[originalLength - i];
			currentDeer.updateStatuses();
		}
	}
	
	public function modifyFood(amount:Int){
		currentFood += amount;
		if(currentFood < 0){
			currentFood = 0;
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
	}
	
	public function prepareDeer(){
		for(i in 0...controlledDeer.length){
			if(controlledDeer[i].currentAction == "Waiting"){
				controlledDeer[i].currentAction = "Foraging";
			}
		}
	}
	
	public function loseAllDeer(){
		if(controlledDeer.length <= 1){
			return;
		}
		
		//loop backwards through controlled deer
		var originalLength:Int = controlledDeer.length;
		for (i in 1...originalLength) {
			var currentDeer:Deer = controlledDeer[originalLength - i];
			loseControlledDeer(currentDeer);
		}
	}
	
	public function loseControlledDeer(deer:Deer){
		if(currentLocationName == "Unfamiliar Woods"){
			unfamiliarWoodsLostDeer[unfamiliarWoodsLostDeer.length] = deer;
		}else if(currentLocationName == "Abandoned Fields"){
			abandonedFieldsLostDeer[abandonedFieldsLostDeer.length] = deer;
		}else{
			unfamiliarWoodsLostDeer[unfamiliarWoodsLostDeer.length] = deer;
		}
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
	
	public function loadFromSave(){
		
	}
	
	public function saveGameData(){
		
	}
	
	public function addUnfamiliarWoodsRabbitFur(){
		unfamiliarWoodsDenRabbitFur++;
		if(unfamiliarWoodsDenRabbitFur > 5){
			unfamiliarWoodsDenRabbitFur = 5;
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
		
		//UnfamiliarWoods
		unfamiliarWoodsMaxFood = 10;
		unfamiliarWoodsDenRabbitFur = 0;
		unfamiliarWoodsLostDeer = new Array<Deer>();
		unfamiliarWoodsCaveFound = false;
		unfamiliarWoodsMedallionTaken = false;
		unfamiliarWoodsDeepWoodsFound = false;
		unfamiliarWoodsDeepWoodsThicketNavigated = false;
		unfamiliarWoodsDeepWoodsThicketCleared = false;
		
		abandonedFieldsMaxFood = 12;
	}
}