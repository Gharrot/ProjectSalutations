package locations;

import flixel.math.FlxRandom;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class StoneStrongholdEntrance extends Location
{
	public function new(){
		super();
		
		name = "Stone Stronghold Entrance";
		backgroundImageFile = "assets/images/LocationImages/StoneOverlook.png";
		backgroundImageFileNoFrame = "assets/images/LocationImages/StoneOverlookNoFrame.png";
		backgroundImageFileMiniFramed = "assets/images/LocationImages/StoneOverlookEmptyDeerTile.png";
	}
	
	override public function explore(deer:Deer)
	{
		var exploreOptionNames:Array<String> = new Array<String>();
		var exploreOptionFunctions:Array<(String, Deer)->Void> = new Array<(String, Deer)->Void>();

		//The Stone Door 
		exploreOptionNames.push("The Stone Door");
		exploreOptionFunctions.push(theStoreDoor);

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
		message.push("Directly ahead of you is a low stone pedestal.");
		showChoice(message, ["Check the pedestal"], [stonePedestal], deer);
	}
	
	function stonePedestal(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("You walk up to the stone pedestal.");
		
		if (GameVariables.instance.undergroundCityOpened)
		{
			message.push("As you walk up to the pedestal it slides back, revealing the entrance to the underground city.");
			message.push("(You can head back into the city using the map)");
			showChoice(message, ["Continue"], [continueOnChoice], deer);
		}
		else
		{
			if (GameVariables.instance.getMedallionCount() >= 1)
			{
				message.push("The stone pedestal is bare other than a shallow circular indentation on top.");
				showChoice(message, ["Place a medallion"], [placingAMedallion], deer);
			}
			else
			{
				message.push("The stone pedestal is bare other than a shallow circular indentation on top.");
				showResult(message);
			}
		}
	}
	
	function placingAMedallion(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("You place a medallion on the pedestal and it begins to glow softly.");
		message.push("You pick the medallion up off the pedestal and it continues to glow.");
		message.push("The pedestal slides back, revealing a stone staircase descending into the ground.");
		showChoice(message, ["Head down the stairs"], [discoveringTheUndergroundCity], deer);
	}
	
	function discoveringTheUndergroundCity(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		GameVariables.instance.undergroundCityOpened = true;
		
		message.push("The stairs and dimly lit and continue downwards for quite a distance, descending deep into the earth.");
		message.push("After some time the stairs level off and you're breifly blinded as you hear hundreds of lights switch on.");
		message.push("You step forward into a massive open area carved underground filled with stone buildings.");
		showChoice(message, ["Look around a bit"], [explainingTheUndergroundCity], deer);
	}
	
	function explainingTheUndergroundCity(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("As you walk the city streets the doors of buildings you pass slide open.");
		message.push("Looking inside a few of them, you find cold storage areas filled with produce in each one.");
		message.push("Each building also has a room with bedding, and another with a fountain.");
		message.push("Any deer you leave here should be safe, well fed, and happy to wait around for you.");
		message.push("(You can leave deer here and pick them up later using the 'drop off' button found on the den menu)");
		showChoice(message, ["Continue"], [enterTheUndergroundCity], deer);
	}
	
	function enterTheUndergroundCity(choice:String, deer:Deer)
	{
		GameVariables.instance.changeLocation("Underground City");
		resetDailyVariables();
		returnAfterDayEnd();
	}
	
	override public function forage(deer:Deer) 
	{
		var randomNums:FlxRandom = new FlxRandom();
		
		GameVariables.instance.modifyFood(3);
		showResult(["Some nearby squirrels see you searching for food and offer you some chestnuts (+3 food)."]);
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