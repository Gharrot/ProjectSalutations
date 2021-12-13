package locations;

import haxe.Int64Helper;
import statuses.DeerStatusEffect;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxAxes;
import flixel.math.FlxRandom;


class DarkCity extends Location
{

	public function new(){
		super();
		
		name = "Dark City";
		backgroundImageFile = "assets/images/LocationImages/OnsenTop.png";
		backgroundImageFileNoFrame = "assets/images/LocationImages/OnsenTopNoFrame.png";
		backgroundImageFileMiniFramed = "assets/images/LocationImages/OnsenTopEmptyDeerTile.png";
	}
	
	override public function explore(deer:Deer)
	{
		var exploreOptionNames:Array<String> = new Array<String>();
		var exploreOptionFunctions:Array<(String, Deer)->Void> = new Array<(String, Deer)->Void>();

		//Astronomy Lab 
		if (GameVariables.instance.undergroundCityObservatoryViewed)
		{
			exploreOptionNames.push("The Observatory");
		}
		else
		{
			exploreOptionNames.push("???");
		}
		exploreOptionFunctions.push(enterObservatory);

		//The Church 
		if (GameVariables.instance.undergroundCityChurchViewed)
		{
			exploreOptionNames.push("The Chapel");
		}
		else
		{
			exploreOptionNames.push("???");
		}
		exploreOptionFunctions.push(enterChurch);

		//The Pods 
		if (GameVariables.instance.undergroundCityLabsViewed)
		{
			exploreOptionNames.push("The Lab");
		}
		else
		{
			exploreOptionNames.push("???");
		}
		exploreOptionFunctions.push(enterPods);

		showChoice(["Where will you head to?"], exploreOptionNames, exploreOptionFunctions, deer);
	}
	
	public function enterObservatory(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("You walk into the observatory.");
		showResult(message);
	}
	
	public function enterChurch(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("You walk into the church.");
		showResult(message);
	}
	
	public function enterPods(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("You walk into the lab filled with pods.");
		showResult(message);
	}
	
	override public function forage(deer:Deer) 
	{
		var randomNums:FlxRandom = new FlxRandom();
		var forageResult = (deer.int * 2) + (deer.lck) + randomNums.int(0, 10);
		
		if(forageResult <= 6){
			showResult(["You are unable to find any food today."]);
		}else if(forageResult <= 11){
			GameVariables.instance.modifyFood(2);
			showResult(["You find some shrubs growing in the empty greenhouses (+2 food)."]);
		}else if(forageResult <= 17){
			GameVariables.instance.modifyFood(3);
			showResult(["You find a large patch of shrubbery growing next to a broken water fountain (+3 food)."]);
		}else{
			GameVariables.instance.modifyFood(4);
			showResult(["You find a giant stash of chestnuts buried behind a house (+4 food)."]);
		}
	}
	
	override public function defend(deer:Array<Deer>)
	{
		if (deer.length > 0)
		{
			showResult(["The mountain peak is peaceful, and nothing attacks your den."]);
		}
		else
		{
			setOut();
		}
	}
	
	override public function hunt(deer:Array<Deer>) {
		showResult(["There doesn't seem to be anything to hunt up here."]);
	}
}