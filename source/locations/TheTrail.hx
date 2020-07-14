package locations;

import statuses.DeerStatusEffect;

import flixel.math.FlxRandom;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class TheTrail extends Location
{

	public function new(){
		super();
		
		name = "The Trail";
		backgroundImageFile = "assets/images/LocationImages/AbandonedFields.png";
		backgroundImageFileNoFrame = "assets/images/LocationImages/AbandonedFieldsNoFrame.png";
		backgroundImageFileMiniFramed = "assets/images/LocationImages/AbandonedFieldsEmptyDeerTile.png";
	}
	
	override public function returnAfterDayEnd()
	{
		
	}
	
	override public function explore(deer:Deer)
	{
		
	}
	
	public function wander(choice:String, deer:Deer)
	{
		
	}
	
	override public function forage(deer:Deer) {
		var randomNums:FlxRandom = new FlxRandom();
		var forageResult = (deer.int * 2) + (deer.lck) + randomNums.int(0, 10);
		
		if(forageResult <= 6){
			showResult(["You are unable to find any food today."]);
		}else if(forageResult <= 11){
			GameVariables.instance.modifyFood(2);
			showResult(["You find a pile of acorns to eat (+2 food)."]);
		}else if(forageResult <= 17){
			GameVariables.instance.modifyFood(3);
			showResult(["You find some turnips and dig them up (+3 food)."]);
		}else{
			GameVariables.instance.modifyFood(4);
			showResult(["You find a tree surrounded by fallen chestnuts and gather as many as you can (+4 food)."]);
		}
	}
	
	override public function defend(deer:Array<Deer>)
	{
		
	}
	
	override public function hunt(deer:Array<Deer>) {
		var randomNums:FlxRandom = new FlxRandom();
		var message:Array<String> = new Array<String>();
		
		showResult(message);
	}
}