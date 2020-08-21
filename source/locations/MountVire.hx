package locations;

import statuses.DeerStatusEffect;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxAxes;
import flixel.math.FlxRandom;

class MountVire extends Location
{
	var movingUpwards:String = "No";
	
	public function new(){
		super();
		
		name = "Mount Vire";
		backgroundImageFile = "assets/images/LocationImages/GhostTown.png";
		backgroundImageFileNoFrame = "assets/images/LocationImages/GhostTownNoFrame.png";
		backgroundImageFileMiniFramed = "assets/images/LocationImages/GhostTownEmptyDeerTile.png";
	}
	
	override public function returnAfterDayEnd()
	{
		var gameVariables:GameVariables = GameVariables.instance;
		var message:Array<String> = new Array<String>();
		
		if (gameVariables.mountVireLocation == "Base camp")
		{
			if (movingUpwards == "Yes")
			{
				mountainMovement("Goat plateau");
			}
		}
	}
	
	public function mountainMovement(destination:String)
	{
		var gameVariables:GameVariables = GameVariables.instance;
		var message:Array<String> = new Array<String>();
		if (destination == "Goat plateau")
		{
			gameVariables.mountVireLocation = "Goat plateau";
			
			message.push("Your herd treks up the mountain for a while and comes to a large plateau filled with goats.");
			message.push("The goats stare at you for a moment then bound off and up the nearby cliffsides.");
			showChoice(message, ["Continue"], [enterGoatPlateau], gameVariables.getPlayerDeer());
		}
	}
	
	override public function explore(deer:Deer)
	{
		var gameVariables:GameVariables = GameVariables.instance;
		
		var exploreOptionNames:Array<String> = new Array<String>();
		var exploreOptionFunctions:Array<(String, Deer)->Void> = new Array<(String, Deer)->Void>();
		
		if (gameVariables.mountVireLocation == "Base camp")
		{
			//Coffee tent
			exploreOptionNames.push("Coffee tent");
			exploreOptionFunctions.push(coffeeTent);
			
			//Mountain trail
			exploreOptionNames.push("Mountain trail");
			exploreOptionFunctions.push(mountainTrail);
		}
		else if (gameVariables.mountVireLocation == "Goat plateau")
		{
			//Coffee tent
			exploreOptionNames.push("Coffee tent");
			exploreOptionFunctions.push(coffeeTent);
			
			//Mountain trail
			exploreOptionNames.push("Mountain trail");
			exploreOptionFunctions.push(mountainTrail);
		}

		showChoice(["Where will you head to?"], exploreOptionNames, exploreOptionFunctions, deer);
	}
	
	public function coffeeTent(deer:Deer, choice:String)
	{
		var message:Array<String> = new Array<String>();
		message.push("You walk into one of the camps larger tents and find a dozen or so squirrels sitting around a fire sipping on warm drinks.");
		message.push("A few kettles are brewing beverages on the fire; one of the squirrels motions for you to pour yourself something.");
		
		var drinkNames:Array<String> = new Array<String>();

		drinkNames.push("Acorn Brew");
		drinkNames.push("Sleepy Spruce Tea");
		drinkNames.push("Chucklebean Blend");

		showChoice(message, drinkNames, [coffeeDrinking], deer);
	}
	
	public function coffeeDrinking(choice:String, deer:Deer)
	{
		var message:Array<String> = new Array<String>();
		
		if (choice == "Acorn Brew")
		{
			//+2 luck for 4 days
			message.push("You grab a kettle off the fire and pour yourself a cup of coffee.");
			message.push("The flavour tastes just like munching on acorns.");
			message.push("(+2 luck for 4 days).");
			deer.addStatusEffect(new DeerStatusEffect("Lucky as an Acorn", 4, 0, 0, 0, 0, 3));
		}
		else if (choice == "Sleepy Spruce Tea")
		{
			//+2 health while resting for 4 days
			message.push("You grab a kettle off the fire and pour yourself a cup of tea.");
			message.push("The flavour tastes just like munching on spruce needles.");
			message.push("(+2 health while resting for 4 days).");
			deer.addStatusEffect(new DeerStatusEffect("Sleepy as a Spruce Tree", 4, 0, 0, 0, 0, 0));
		}
		else if (choice == "Chucklebean Blend")
		{
			//+2 dexterity for 4 days
			message.push("You grab a kettle off the fire and pour yourself a cup of coffee.");
			message.push("The flavour tastes just like munching on beans.");
			message.push("(+2 dexterity for 4 days).");
			deer.addStatusEffect(new DeerStatusEffect("Chuckled as a Bean", 4, 0, 0, 2, 0, 0));
		}
		
		showResult(message);
	}
	
	public function mountainTrail(deer:Deer, choice:String)
	{
		var gameVariables:GameVariables = GameVariables.instance;
		var message:Array<String> = new Array<String>();
		
		if (gameVariables.mountVireMountainPathBlockage > 0)
		{
			if (gameVariables.mountVireMountainPathBlockage >= 5)
			{
				message.push("You start to trek up the mountain, but are quickly stopped by a blockage on the path.");
				message.push("The path ahead is blocked by many large rocks.");
			}
			else if (gameVariables.mountVireMountainPathBlockage >= 3)
			{
				message.push("You start to trek up the mountain, but are stopped by a blockage on the path.");
				message.push("The path ahead is blocked by a few large rocks.");
			}
			else if (gameVariables.mountVireMountainPathBlockage == 2)
			{
				message.push("You trek up the mountain for a bit, but are eventually stopped by a blockage on the path.");
				message.push("The path ahead is blocked by a couple large rocks.");
			}
			else if (gameVariables.mountVireMountainPathBlockage == 1)
			{
				message.push("You trek up the mountain for a bit, but are eventually stopped by a blockage on the path.");
				message.push("The path ahead is blocked by a large rock.");
			}
			
			if (gameVariables.mountVireExplosives > 0)
			{
				message.push(SquirrelVillage.getExplosivesStatus(false));
				showChoice(message, ["Set off an explosive", "Move some rocks", "Head back"], [setoffExplosionMoutainPath, moveRocksMoutainPath, continueOnChoice], deer);
			}
			else
			{
				showChoice(message, ["Move some rocks", "Head back"], [moveRocksMoutainPath, continueOnChoice], deer);
			}
		}
		else
		{
			message.push("You start to trek up the mountain a bit, running into no obstacles.");
			
			if (movingUpwards == "No")
			{
				message.push("Will you head further up the mountain? Your herd will follow you at the end of the day.");
				showChoice(message, ["Head up the mountain", "Head back"], [continueUpTheMountainPath, continueOnChoice], deer);
			}
			else
			{
				message.push("Another deer is already headed further up the path, will you call them back?");
				message.push("(This would stop the whole herd from heading up the mountain at the end of the day)");
				showChoice(message, ["Call them back", "Follow along"], [cancelMountainPathTrek, continueOnChoice], deer);
			}
		}
	}
	
	public function setoffExplosionMoutainPath(deer:Deer, choice:String)
	{
		var gameVariables:GameVariables = GameVariables.instance;
		var message:Array<String> = new Array<String>();
		gameVariables.mountVireMountainPathBlockage -= 3;
		message.push("KABLAM!");
		
		if (gameVariables.mountVireMountainPathBlockage > 0)
		{
			message.push("You set off an explosive and it destroys most of the rocks on the path.");
			
			if (gameVariables.mountVireMountainPathBlockage == 2)
			{
				message.push("The path is still blocked by another couple large rocks.");
			}
			else if (gameVariables.mountVireMountainPathBlockage == 1)
			{
				message.push("The path is still blocked by another large rock.");
			}
			
			message.push(SquirrelVillage.getExplosivesStatus(true));
			showResult(message);
		}
		else
		{
			gameVariables.mountVireMountainPathBlockage = 0;
			message.push("You set off an explosive and it destroys all of the rocks on the path.");
			message.push(SquirrelVillage.getExplosivesStatus(true));
			message.push("Will you head further up the mountain? Your herd will follow you at the end of the day.");
			showChoice(message, ["Head up the mountain", "Head Back"], [continueUpTheMountainPath, continueOnChoice], deer);
		}
	}
	
	public function moveRocksMoutainPath(deer:Deer, choice:String)
	{
		var gameVariables:GameVariables = GameVariables.instance;
		var message:Array<String> = new Array<String>();
		var rockMovingSkill:Int = deer.str*2 + deer.res + randomNums.int(0, 5);
		
		if (rockMovingSkill >= 19)
		{
			message.push(deer.getName() + " spends the day pushing rocks out of the way, managing to move a few of the large rocks.");
			gameVariables.mountVireMountainPathBlockage -= 3;
		}
		else if (rockMovingSkill >= 14)
		{
			message.push(deer.getName() + " spends the day pushing rocks out of the way, managing to move a couple of the large rocks.");
			gameVariables.mountVireMountainPathBlockage -= 2;
		}
		else if (rockMovingSkill >= 10)
		{
			message.push(deer.getName() + " spends the day pushing rocks out of the way, managing to move one of the large rocks.");
			gameVariables.mountVireMountainPathBlockage -= 1;
		}
		else
		{
			message.push(deer.getName() + " spends the day trying to push rocks out of the way, but isn't strong enough to make any real progress.");
		}
		
		if (gameVariables.mountVireMountainPathBlockage >= 5)
		{
			message.push("The path ahead remains blocked by many large rocks.");
		}
		else if (gameVariables.mountVireMountainPathBlockage >= 3)
		{
			message.push("The path ahead remains blocked by a few large rocks.");
		}
		else if (gameVariables.mountVireMountainPathBlockage == 2)
		{
			message.push("The path ahead remains blocked by a couple large rocks.");
		}
		else if (gameVariables.mountVireMountainPathBlockage == 1)
		{
			message.push("The path ahead remains blocked by a large rock.");
		}
		
		if (gameVariables.mountVireMountainPathBlockage <= 0)
		{
			gameVariables.mountVireMountainPathBlockage = 0;
			message.push("The path ahead has been successfully cleared.");
			message.push("Will you head further up the mountain? Your herd will follow you at the end of the day.");
			showChoice(message, ["Head up the mountain", "Head Back"], [continueUpTheMountainPath, continueOnChoice], deer);
		}
		else
		{
			showResult(message);
		}
	}
	
	public function continueUpTheMountainPath(deer:Deer, choice:String)
	{
		movingUpwards = "Yes";
		continueOn();
	}
	
	public function cancelMountainTrekPath(deer:Deer, choice:String)
	{
		var message:Array<String> = new Array<String>();
		
		movingUpwards = "No";
		
		message.push("You call the deer further up the mountain back and you head to camp together.");		
		showResult(message);
	}
	
	override public function forage(deer:Deer) {
		var randomNums:FlxRandom = new FlxRandom();
		var message:Array<String> = new Array<String>();
		
		if (GameVariables.instance.mountVireLocation == "Base camp")
		{
			var forageResult = (deer.int * 2) + (deer.lck) + randomNums.int(0, 10);

			if (forageResult <= 9)
			{
				//Found nothing
				message.push("You are unable to find any food today.");
			}
			else if (forageResult <= 14)
			{
				GameVariables.instance.modifyFood(1);
				message.push("You find a small patch of herbs growing on the mountainside (+1 food).");
			}
			else if (forageResult <= 19)
			{
				GameVariables.instance.modifyFood(2);
				message.push("You find a blueberry bush just off a mountain trail (+2 food).");
			}
			else if (forageResult <= 23)
			{
				GameVariables.instance.modifyFood(3);
				message.push("You find a small crabapples tree just off a mountain trail (+3 food).");
			}
			else
			{
				GameVariables.instance.modifyFood(4);
				message.push("You find a tree filled with chestnuts in a small mountain grove (+4 food).");
			}
		}
		
		showResult(message);
	}
	
	override public function defend(deer:Array<Deer>)
	{
		if (GameVariables.instance.mountVireLocation == "Base camp")
		{
			if (deer.length > 0)
			{
				showResult(["It seems there's nothing that will attack your den on this part of the mountain."]);
			}
			else
			{
				setOut();
			}
		}
		
	}
	
	override public function hunt(deer:Array<Deer>) {
		if (GameVariables.instance.mountVireLocation == "Base camp")
		{
			if (deer.length > 0)
			{
				showResult(["It seems there's nothing to hunt on this area of the mountain."]);
			}
			else
			{
				setOut();
			}
		}
	}
}