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
		var exploreOptionNames:Array<String> = new Array<String>();
		var exploreOptionFunctions:Array<(String, Deer)->Void> = new Array<(String, Deer)->Void>();

		//The Bar 
		exploreOptionNames.push("The Bar");
		exploreOptionFunctions.push(theBar);
		
		//The Trail
		exploreOptionNames.push("The Trail");
		exploreOptionFunctions.push(theTrail); 

		showChoice(["Where will you head to?"], exploreOptionNames, exploreOptionFunctions, deer);
	}
	
	//Visit The Bar with a deer named ZAZ 
	public function theBar(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		
		if (GameVariables.instance.undergroundCityReached)
		{
			message.push("You head into the bar.");
			message.push("Other than the trapdoor leading to the train station you don't find anything of interest.");
			showChoice(message, ["Follow the tunnel", "Head back"], [headToTheCity, continueOnChoice], deer);
		}
		else
		{
			message.push("You head into the bar.");
			message.push("You look around a bit, but don't find much of interest.");
			showResult(message); 
		}
	}
	
	public function headToTheCity(choice:String, deer:Deer)
	{
		
	}
	
	public function theTrail(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("On the east end of town you find a dirt path that leads across a field and into the distance.");
		message.push("The trail calls to you, and you can hardly resist just following it right now.");
		message.push("(Something tells you this trail is not a short one, and your herd should be prepared for a long journey.)");
		
		showChoice(message, ["Follow the trail", "Head back"], [takingTheTrail, continueOnChoice], deer);
	}
	
	public function takingTheTrail(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("You gather your herd and set off down the trail.");
		message.push("After a short ways, you stop to plan out what each deer should do for the day.");
		showChoice(message, ["Continue"], [takingTheTrailFinalizing], deer);
	}
	
	public function takingTheTrailFinalizing(choice:String, deer:Deer)
	{
		GameVariables.instance.changeLocation("The Trail");
		resetDailyVariables();
		returnAfterDayEnd();
	}
	
	override public function forage(deer:Deer) {
		var randomNums:FlxRandom = new FlxRandom();
		
		GameVariables.instance.modifyFood(5);
		showResult(["You gather plenty of food from one of the town's many overgrown gardens (+5 food)."]);
	}
	
	override public function defend(deer:Array<Deer>)
	{
		if (deer.length > 0)
		{
			showResult(["Luckily this ghost town contain no actual ghosts, or any other danger to defend against."]);
		}
		else
		{
			setOut();
		}
	}
	
	override public function hunt(deer:Array<Deer>) {
		showResult(["Your hunting pack wanders around the town, but there seems to be nothing to hunt."]);
	}
}