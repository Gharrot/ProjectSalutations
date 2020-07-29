package locations;

import flixel.math.FlxRandom;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class StoneStrongholdEntrance extends Location
{
	public function new(){
		super();
		
		name = "Stone Stronghold Entrance";
		backgroundImageFile = "assets/images/LocationImages/GhostTown.png";
		backgroundImageFileNoFrame = "assets/images/LocationImages/GhostTownNoFrame.png";
		backgroundImageFileMiniFramed = "assets/images/LocationImages/GhostTownEmptyDeerTile.png";
	}
	
	override public function explore(deer:Deer)
	{
		var exploreOptionNames:Array<String> = new Array<String>();
		var exploreOptionFunctions:Array<(String, Deer)->Void> = new Array<(String, Deer)->Void>();

		//The Stone Door 
		exploreOptionNames.push("The Stone Door");
		exploreOptionFunctions.push(theBar);
		
		//The Wooden Village
		exploreOptionNames.push("The Wooden Village");
		exploreOptionFunctions.push(theTrail); 

		showChoice(["Where will you head to?"], exploreOptionNames, exploreOptionFunctions, deer);
	}
	
	public function theStoreDoor(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("You walk over to the stone door; it slides open as you approach.");
		showChoice(message, ["Step inside"], [insideTheStoreDoor], deer);
	}
	
	function insideTheStoreDoor(choice:String, deer:Deer)
	{
		GameVariables.instance.undergroundCityReached = true;
		
		var message:Array<String> = new Array<String>();
		message.push("You step into a moderate-sized stone room.");
		message.push("A staircase to your left leads down a bit, then continues as a tunnel. The tunnel seems to lead back to the bar in the ghost town you came from.");
		message.push("Directly ahead of you is a low stone pedestal.");
		showChoice(message, ["Follow the tunnel", "Check the pedestal"], [headToTheBar, stonePedestal], deer);
	}
	
	function headToTheBar(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("You head down the staircase and follow the tunnel back to the ghost town.");
		showChoice(message, ["Continue"], [takingTheTunnel], deer);
	}
	
	function takingTheTunnel(choice:String, deer:Deer)
	{
		GameVariables.instance.changeLocation("Ghost Town");
		resetDailyVariables();
		returnAfterDayEnd();
	}
	
	function stonePedestal(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("You walk up to the stone pedestal.");
		
		if (GameVariables.instance.undergroundCityOpened)
		{
			
		}
		else
		{
			if (GameVariables.instance.getMedallionCount() >= 1)
			{
				
			}
			else
			{
				
			}
		}
	}
	
	public function theWoodenVillage(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("You head over to the entrance of the wooden village, but a group of squirrels scurry over and stop you.");
		message.push("It seems they're not ready for you yet.");
		message.push("(You'll have to wait for a future update, sorry)");
		showResult(message);
	}
	
	override public function forage(deer:Deer) 
	{
		var randomNums:FlxRandom = new FlxRandom();
		
		GameVariables.instance.modifyFood(3);
		showResult(["Some nearby squirrels see you searching for food and offer you some acorns (+3 food)."]);
	}
	
	override public function defend(deer:Array<Deer>)
	{
		if (deer.length > 0)
		{
			showResult(["It seems there's nothing that will attack your den here. It's likely thanks to the squirrel guards patrolling the area."]);
		}
		else
		{
			setOut();
		}
	}
	
	override public function hunt(deer:Array<Deer>) {
		showResult(["Your hunting pack wanders around the area, but there seems to be nothing to hunt."]);
	}
}