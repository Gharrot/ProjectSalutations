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
	
	function medallionPedestal(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("On the far end of town you find a tall stone chapel.");
		message.push("The chapel is completely empty, save for a pedestal on the far end of the room.");
		message.push("The pedestal is bare, with 3 circular indentations on top and a keyhole below them.");
		message.push("(This area, and more exploration of the city will open up in a later update.)");
		message.push("(You can still find the 3 medallions and key in this version though.)");
		
		if (GameVariables.instance.getMedallionCount() >= 3 && GameVariables.instance.mountVireKeyTaken)
		{
			message.push("(Which you already did, congratulations! This is as far as the game goes right now, thank you so much for playing!)");
		}
		
		showResult(message);
	}
	
	public function enterObservatory(choice:String, deer:Deer)
	{
		GameVariables.instance.undergroundCityObservatoryViewed = true;
		var message:Array<String> = new Array<String>();
		message.push("You walk into a small tall room carved into the back wall of the city.");
		message.push("The room is filled with screens and devices connected to a center terminal.");
		message.push("The domed ceiling is lined with diagrams of stars, though they're impossible to clearly make out in the dim light.");
		message.push("Rocks seem to have fallen from the roof smashing important part of the system, rendering everything unusable.");
		showResult(message);
	}
	
	public function enterChurch(choice:String, deer:Deer)
	{
		GameVariables.instance.undergroundCityChurchViewed = true;
		var message:Array<String> = new Array<String>();
		message.push("You walk over to investigate the chapel located at the back of the city.");
		message.push("Unfortunately the entrance has completely caved in and there's no hope of getting through.");
		showResult(message);
	}
	
	public function enterPods(choice:String, deer:Deer)
	{
		GameVariables.instance.undergroundCityLabsViewed = true;
		var message:Array<String> = new Array<String>();
		message.push("You walk into a large room carved into the back wall of the city.");
		message.push("The walls of the room are lined with glass pods attached to machines by clear tubes. The floor is covered in a slimy green residue.");
		message.push("Nearly all of the pods appear to have been broken open by chunks of rock that fell from the roof.");
		message.push("There doesn't seem to be anything useful still able to be done here.");
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