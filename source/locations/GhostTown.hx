package locations;

import statuses.DeerStatusEffect;

import flixel.math.FlxRandom;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class GhostTown extends Location
{

	public function new(){
		super();
		
		name = "Ghost Town";
		backgroundImageFile = "assets/images/LocationImages/GhostTown.png";
		backgroundImageFileNoFrame = "assets/images/LocationImages/GhostTownNoFrame.png";
		backgroundImageFileMiniFramed = "assets/images/LocationImages/GhostTownEmptyDeerTile.png";
	}
	
	override public function explore(deer:Deer)
	{
		continueCount = 0;

		var exploreOptionNames:Array<String> = new Array<String>();
		var exploreOptionFunctions:Array<(String, Deer)->Void> = new Array<(String, Deer)->Void>();

		//The Bar
		//Visit The Bar with a deer named ZAZ  
		exploreOptionNames.push("The Bar");
		exploreOptionFunctions.push(greatFlame);
		
		//The Trail
		exploreOptionNames.push("The Trail");
		exploreOptionFunctions.push(greatFlame); 

		if (exploreOptionNames.length <= 1)
		{
			wander("", deer);
		}
		else
		{
			showChoice(["Where will you head to?"], exploreOptionNames, exploreOptionFunctions, deer);
		}
	}
	
	public function theBar()
	{
		var message:Array<String> = new Array<String>();
		
		if (GameVariables.instance.undergroundCityReached)
		{
			
		}
		else
		{
			
		}
		message.push("On the east end of town you find a dirt path that leads across a field and into the distance.");
		message.push("The trail calls to you, and you can hardly resist just following it right now.");
		message.push("(Something tells you this trail is not a short one, and your herd should be prepared for a long journey.)");
		
		showChoice(message, ["Follow the trail", "Head back"], [takingTheTrail, continueOnChoice], deer);
	}
	
	public function theTrail()
	{
		var message:Array<String> = new Array<String>();
		message.push("On the east end of town you find a dirt path that leads across a field and into the distance.");
		message.push("The trail calls to you, and you can hardly resist just following it right now.");
		message.push("(Something tells you this trail is not a short one, and your herd should be prepared for a long journey.)");
		
		showChoice(message, ["Follow the trail", "Head back"], [takingTheTrail, continueOnChoice], deer);
	}
	
	public function takingTheTrail()
	{
		
	}
	
	override public function forage(deer:Deer) {
		var randomNums:FlxRandom = new FlxRandom();
		
		GameVariables.instance.modifyFood(5);
		showResult(["You gather plenty of food from one of the town's many overgrown gardens (+5 food)."]);
	}
	
	override public function defend(deer:Array<Deer>)
	{
		showResult(["Luckily this ghost town contain no actual ghosts, or any other danger to defend against."]);
	}
	
	override public function hunt(deer:Array<Deer>) {
		showResult(["Your hunting pack wanders around the town, but there seems to be nothing to hunt."]);
	}
}