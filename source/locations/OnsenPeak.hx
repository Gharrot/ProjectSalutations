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


class OnsenPeak extends Location
{

	public function new(){
		super();
		
		name = "Onsen Peak";
		backgroundImageFile = "assets/images/LocationImages/OnsenTop.png";
		backgroundImageFileNoFrame = "assets/images/LocationImages/OnsenTopNoFrame.png";
		backgroundImageFileMiniFramed = "assets/images/LocationImages/OnsenTopEmptyDeerTile.png";
	}
	
	override public function explore(deer:Deer)
	{
		var exploreOptionNames:Array<String> = new Array<String>();
		var exploreOptionFunctions:Array<(String, Deer)->Void> = new Array<(String, Deer)->Void>();

		//The Hot Springs 
		exploreOptionNames.push("The Hot Springs");
		exploreOptionFunctions.push(theHotSpring);

		showChoice(["Where will you head to?"], exploreOptionNames, exploreOptionFunctions, deer);
	}
	
	public function theHotSpring(choice:String, deer:Deer)
	{
		var gameVariables:GameVariables = GameVariables.instance;
		var message:Array<String> = new Array<String>();
		
		if (deer.player)
		{
			message.push("You find a nice secluded hotspring, step into the water, and drift away.");
			
			if (gameVariables.onsenPeakStatChoice == "None")
			{
				message.push("(You may choose a stat to permanently increase)");
				message.push("(You may come back here to change the stat later)");
			}
			else
			{
				message.push("(You may choose a stat to permanently increase)");
				message.push("(The stat you chose earlier has decreased back to normal)");
			}
			
			message.push("(Or you can just relax for a stat boost)");
			
			showChoice(message, ["Strength", "Resilience", "Dexterity", "Intellect", "Fortune", "Relax"], [playerOnsenRelaxing], deer);
		}
		else
		{
			message.push("You find a nice secluded hotspring, step into the water, and drift away.");
			message.push("(+2 Intellect and +3 Fortune for 4 days)");
			deer.addStatusEffect(new DeerStatusEffect("Onsen Relaxation", 5, 0, 0, 0, 2, 3));
			
			if (gameVariables.onsenPeakStatChoice == "None")
			{
				message.push("(You feel " + gameVariables.getPlayerDeer().getName() + " would appreciate this spring even better)");
			}
			
			showChoice(message, ["Continue"], [continueOnChoice], deer);
		}
	}
	
	public function playerOnsenRelaxing(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		message.push("You slide deeper into the hot spring and drift away...");
		
		if (choice == "Relax")
		{
			message.push("(+2 Intellect and +3 Fortune for 4 days)");
			deer.addStatusEffect(new DeerStatusEffect("Onsen Relaxation", 5, 0, 0, 0, 2, 3));
		}
		else
		{
			//Remove stat
			if (GameVariables.instance.onsenPeakStatChoice != "None")
			{
				GameVariables.instance.getPlayerDeer().modifyStatByName(GameVariables.instance.onsenPeakStatChoice, -1);
			}
			
			GameVariables.instance.onsenPeakStatChoice = choice;
			GameVariables.instance.getPlayerDeer().modifyStatByName(choice, 1);
			message.push("(+1 permanent " + choice + ")");
		}
		
		showResult(message);
	}
	
	override public function forage(deer:Deer) 
	{
		var randomNums:FlxRandom = new FlxRandom();
		
		GameVariables.instance.modifyFood(3);
		showResult(["Some squirrels bathing in the springs see you scrounging for food and offer you some of their chestnuts (+3 food)."]);
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