package locations;

import flixel.math.FlxRandom;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class UndergroundCity extends Location
{
	public function new(){
		super();
		
		name = "Underground City";
		backgroundImageFile = "assets/images/LocationImages/UndergroundCity.png";
		backgroundImageFileNoFrame = "assets/images/LocationImages/UndergroundCityNoFrame.png";
		backgroundImageFileMiniFramed = "assets/images/LocationImages/UndergroundCityEmptyDeerTile.png";
	}
	
	override public function explore(deer:Deer)
	{
		var exploreOptionNames:Array<String> = new Array<String>();
		var exploreOptionFunctions:Array<(String, Deer)->Void> = new Array<(String, Deer)->Void>();

		//The Shrine 
		exploreOptionNames.push("The Chapel");
		exploreOptionFunctions.push(medallionPedestal);

		showChoice(["Where will you head to?"], exploreOptionNames, exploreOptionFunctions, deer);
	}
	
	function medallionPedestal(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("On the far end of town you find a tall stone chapel.");
		message.push("The chapel is completely empty, save for a pedestal on the far end of the room.");
		message.push("The pedestal is bare, with 3 circular indentations on top.");
		message.push("(This area, and more exploration of the city will open up in a later update.)");
		message.push("(You can still find the 3 medallions in this version though.)");
		
		if (GameVariables.instance.getMedallionCount() >= 3)
		{
			message.push("(Which you already did, congratulations!)");
		}
		
		showResult(message);
	}
	
	override public function forage(deer:Deer) 
	{
		var randomNums:FlxRandom = new FlxRandom();
		
		GameVariables.instance.modifyFood(5);
		showResult(["You gather some food from one of the nearby greenhouses (+5 food)."]);
	}
	
	override public function defend(deer:Array<Deer>)
	{
		if (deer.length > 0)
		{
			showResult(["Your group of defenders patrol the city, but it seems like there's nothing to defend against down here."]);
		}
		else
		{
			setOut();
		}
	}
	
	override public function hunt(deer:Array<Deer>) {
		showResult(["Your hunting pack explores the city, but there seems to be nothing to hunt down here."]);
	}
}