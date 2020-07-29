package locations;

import flixel.math.FlxRandom;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class UndergroundCity extends Location
{
	public function new(){
		super();
		
		name = "Underground City";
		backgroundImageFile = "assets/images/LocationImages/GhostTown.png";
		backgroundImageFileNoFrame = "assets/images/LocationImages/GhostTownNoFrame.png";
		backgroundImageFileMiniFramed = "assets/images/LocationImages/GhostTownEmptyDeerTile.png";
	}
	
	override public function explore(deer:Deer)
	{
		
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